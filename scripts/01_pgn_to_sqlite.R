#### Packages ####
rm(list = ls())
library("magrittr")
library("plyr")
library("dplyr")
library("stringr")
library("RSQLite")


#### Parameters ####
PATH_SQL <- "data-sqlite"
PATH_RAWDATA <- "data-raw"
DB_NAME <- "db.sqlite"
DB_PATH <- file.path(PATH_SQL, DB_NAME) 
VERBOSE <- TRUE

dir.create(PATH_SQL)

# remove if exist!
if (file.exists(DB_PATH)) file.remove(DB_PATH)

db <- dbConnect(SQLite(), dbname = DB_PATH)


#### Process ####
files_pgn <- dir(PATH_RAWDATA, pattern = ".*pgn$", full.names = TRUE)
files_pgn

load_times <- ldply(files_pgn, function(f){ # f <- "data-raw/KingBase2015-09-A80-A99.pgn"
  
  t0 <- Sys.time()
  
  if (VERBOSE) print(f)
  
  flines <- readLines(f)
  
  where_is_no_info <- which(str_length(flines) == 0)
  where_is_no_info <- where_is_no_info[seq(length(where_is_no_info)) %% 2 == 0]
  where_is_no_info <- c(0, where_is_no_info)
  
  df_cuts <- data_frame(from = head(where_is_no_info, -1) + 1,
                       to = tail(where_is_no_info, -1) - 1)
  
  df_games <- ldply(seq(nrow(df_cuts)), function(row){ # row <- 1814
    
    pgn <- flines[seq(df_cuts[row, ]$from, df_cuts[row, ]$to)]
    
    ## data for moves
    moves <- pgn[seq(which(pgn == "") + 1, length(pgn))] %>% 
      paste0(collapse = " ") %>% 
      str_split("\\d+\\.|\\s+") %>% 
      unlist() %>% 
      .[. != ""] %>% 
      head(-1)
    
    ## data game
    headers <- pgn[seq(which(pgn == "")) - 1]
    
    data_keys <- str_extract(headers, "\\w+")
    data_vals <- str_extract(headers, "\".*\"") %>% str_replace_all("\"", "")
    
    df_game <- t(data_vals) %>%
      data.frame(stringsAsFactors = FALSE) %>%
      setNames(data_keys) %>%
      mutate(moves = paste0(moves, collapse = " "))
    
    df_game
    
  }, .progress = ifelse(VERBOSE, "text", "none")) %>% tbl_df()
  
  df_games <- df_games %>% 
    select(Event, Site, Date, Round, White, Black, Result,
           WhiteElo, BlackElo, ECO, moves) %>% 
    mutate(Date = str_replace_all(Date, "\\.", "-"),
           WhiteElo = as.numeric(WhiteElo),
           BlackElo = as.numeric(BlackElo)) %>% 
    setNames(tolower(names(.)))
  
  dbWriteTable(conn = db, name = "games", as.data.frame(df_games),
               row.names = FALSE, append = TRUE)
  
  diff <- difftime(Sys.time(), t0, units = "hours")
  
  df_summary <- data_frame(f, ngames = nrow(df_games), time_hrs = diff)
  
  print(df_summary)
  
  df_summary

}, .progress = ifelse(VERBOSE, "text", "none"))
  
load_times$time_hrs %>% sum()

#### Checks ####
dbListTables(db)

dbGetQuery(db, "select * from games where whiteelo > 2500 limit 10")
dbGetQuery(db, "select count(1) from games")


#### Disconnect ####
dbDisconnect(db)
