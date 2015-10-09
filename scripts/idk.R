#### Packages ####
rm(list = ls())
library("magrittr")
library("plyr")
library("dplyr")
library("rchess")
library("stringr")
library("RSQLite")


#### Parameters ####
PATH_PGN <- "data_pgn"
PATH_SQL <- "data_sqlite"
DB_NAME <- "db.sqlite"
DB_PATH <- file.path(PATH_SQL, DB_NAME) 
VERBOSE <- TRUE

dir.create(PATH_PGN)
dir.create(PATH_SQL)

# remove if exist!
if (file.exists(DB_PATH)) file.remove(DB_PATH)

db <- dbConnect(SQLite(), dbname = DB_PATH)


#### Process ####
files_pgn <- dir("data/", pattern = ".*pgn$", full.names = TRUE)
files_pgn

  
games_by_file <- laply(files_pgn, function(f){ # f <- "data/KingBaseLite2015-05-B20-B49.pgn"
  if(VERBOSE) message(f)
  flines <- readLines(f)
  where_is_no_info <- which(str_length(flines) == 0)
  where_is_no_info <- where_is_no_info[seq(length(where_is_no_info)) %% 2 == 0]
  where_is_no_info <- c(0, where_is_no_info)
  dfcuts <- data_frame(from = head(where_is_no_info, -1) + 1,
                       to = tail(where_is_no_info, -1) - 1)
  nrow(dfcuts)
})

data_frame(files_pgn, games_by_file)
summary(games_by_file)
cumsum(games_by_file)
padwidth <- nchar(max(games_by_file))
rm(games_by_file)


l_ply(files_pgn, function(f){ # f <- "data/KingBaseLite2015-05-A80-A99.pgn" # "data/KingBaseLite2015-05-B20-B49.pgn"
  
  if(VERBOSE) print(f)
  
  flines <- readLines(f)
  
  where_is_no_info <- which(str_length(flines) == 0)
  where_is_no_info <- where_is_no_info[seq(length(where_is_no_info)) %% 2 == 0]
  where_is_no_info <- c(0, where_is_no_info)
  
  dfcuts <- data_frame(from = head(where_is_no_info, -1) + 1,
                       to = tail(where_is_no_info, -1) - 1)
  
  fblock <- str_extract(basename(f), "[A-Z]\\d{2}-[A-Z]\\d{2}")
  
  df_games <- ldply(seq(nrow(dfcuts)), function(row){ # row <- 123
    
    fid <- str_pad(row, width = padwidth, pad = "0")
    fname <- sprintf("%s-%s", fblock, fid)
    
    pgn <- flines[seq(dfcuts[row, ]$from, dfcuts[row, ]$to)]
    
    # writeLines(pgn, con = sprintf("data_pgn/%s.pgn", fname))
    
    ## data for moves
    moves <- pgn[seq(which(pgn == "") + 1, length(pgn))] %>% 
      paste0(collapse = " ") %>% 
      str_split("\\d+\\.|\\s+") %>% 
      unlist() %>% 
      setdiff(c("")) %>% 
      head(-1)
    
    df_moves <- data_frame(move = moves, nmove = seq(length(moves)), internalid = fname)
    
    dbWriteTable(conn = db, name = "games_moves", as.data.frame(df_moves),
                 row.names = FALSE, append = TRUE)
    
    ## data games
    headers <- pgn[seq(which(pgn == "")) - 1]
    
    data_keys <- str_extract(headers, "\\w+")
    data_vals <- str_extract(headers, "\".*\"") %>% str_replace_all("\"", "")
    
    df_game <- t(data_vals) %>%
      data.frame(stringsAsFactors = FALSE) %>%
      setNames(data_keys) %>%
      mutate(interalid = fname)
    
    df_game
    
  }, .progress = ifelse(VERBOSE, "text", "none")) %>% tbl_df()
  
  dbWriteTable(conn = db, name = "games", as.data.frame(df_games),
               row.names = FALSE, append = TRUE)
  
}, .progress = ifelse(VERBOSE, "text", "none"))
  
  
dbListTables(db)
dbListFields(db, "games_moves")      

dbGetQuery(db, "select * from games_moves limit 10")
dbGetQuery(db, "select count(1) from games_moves")


dbDisconnect(db)


