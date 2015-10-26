#### Packages ####
rm(list = ls())
library("magrittr")
library("plyr")
library("dplyr")
library("readr")
library("stringr")
library("RSQLite")


#### Parameters ####
PATH_RAWDATA  <- "data-raw"

PATH_SQL      <- "data-sqlite"
DB_NAME       <- "db.sqlite"
DB_PATH       <- file.path(PATH_SQL, DB_NAME) 

PATH_GZIP     <- "data-gzip"
PATH_ALL     <- "data-all"

VERBOSE       <- TRUE


#### Folders ####
l_ply(c(PATH_SQL, PATH_RDATA, PATH_GZIP), function(x){
  unlink(x, recursive = TRUE)
  file.remove(x)
  dir.create(x)
})

db <- dbConnect(SQLite(), dbname = DB_PATH)


#### Process ####
files_pgn <- dir(PATH_RAWDATA, pattern = ".*pgn$", full.names = TRUE)
files_pgn

load_times <- ldply(files_pgn, function(f){ # f <- sample(files_pgn, size = 1)
  
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
    pgn2 <- pgn[seq(which(pgn == "") + 1, length(pgn))] %>% 
      paste0(collapse = " ") 
    
    ## data game
    headers <- pgn[seq(which(pgn == "")) - 1]
    
    data_keys <- str_extract(headers, "\\w+")
    data_vals <- str_extract(headers, "\".*\"") %>% str_replace_all("\"", "")
    
    df_game <- t(data_vals) %>%
      data.frame(stringsAsFactors = FALSE) %>%
      setNames(data_keys) %>%
      mutate(pgn = pgn2)
    
    df_game
    
  }, .progress = ifelse(VERBOSE, "text", "none")) %>% tbl_df()
  
  df_games <- df_games %>% 
    select(Event, Site, Date, Round, White, Black, Result,
           WhiteElo, BlackElo, ECO, pgn) %>% 
    mutate(Date = str_replace_all(Date, "\\.", "-"),
           WhiteElo = as.numeric(WhiteElo),
           BlackElo = as.numeric(BlackElo)) %>% 
    setNames(tolower(names(.)))
  
  dbWriteTable(conn = db, name = "games", as.data.frame(df_games),
               row.names = FALSE, append = TRUE)
  
  eco <- str_extract(f, "[A-Z]{1}\\d{2}-[A-Z]{1}\\d{2}")
  
  gz <- gzfile(file.path(PATH_GZIP,  sprintf("games_eco_%s.txt.gz", eco)), "w")
  write.table(df_games, file = gz, quote = FALSE, sep = "\t", row.names = FALSE)
  close(gz)
  
  diff <- difftime(Sys.time(), t0, units = "hours")
  
  df_summary <- data_frame(f, ngames = nrow(df_games), time_hrs = diff)
  
  print(df_summary)
  
  df_summary

}, .progress = ifelse(VERBOSE, "text", "none"))
  
load_times %>% summarise(sum(ngames), sum(time_hrs))


#### Checks ####
dbListTables(db)

dbGetQuery(db, "select * from games where whiteelo > 2500 limit 10")
dbGetQuery(db, "select count(1) from games")

#### Disconnect ####
dbDisconnect(db)


#### Write in a one BIG file ####
dfgames <- ldply(dir(PATH_GZIP, full.names = TRUE), read_tsv)
dfgames <- tbl_df(dfgames)

gz <- gzfile(file.path(PATH_ALL, "chess-db.txt.gz"), "w")
write.table(dfgames, file = gz, quote = FALSE, sep = "\t", row.names = FALSE)
close(gz)

save(dfgames, file = file.path(PATH_ALL, "chess-db.RData"))

#### Examples ####
pgn_example <- readLines("data-raw/KingBaseLite2015-10-A00-A39.pgn", n = 30)
pgn_example <- int[seq(0, max(which(int == "")))]

writeLines(pgn_example, con = "example_input.pgn")
write.table(dfgames %>% head(10), file = "example_output.tsv", quote = FALSE, sep = "\t", row.names = FALSE)
write_csv(dfgames %>% head(10), "example_output.csv")

