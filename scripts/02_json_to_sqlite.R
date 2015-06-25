#### wksp & opts ####
rm(list = ls())
options(stringsAsFactors = FALSE)


#### packages ####
library("RSQLite")
library("DBI")
library("jsonlite")
library("plyr")
library("dplyr")
library("magrittr")


#### parameters ####
pgn_file <- "data/millionbase.json"
db_path <- "data/chessdb.sqlite3"
chunk_size <- 100 # games per chunk


#### creating db and load files ####

# remove if exist!
if (file.exists(db_path)) file.remove(db_path)

db <- dbConnect(SQLite(), dbname = db_path)

games_n <- as.numeric(strsplit(system(paste("wc -l", pgn_file), intern = TRUE), " ")[[1]][1])

# we apply chunks to send 100 rows at time instead 1 at time
chunks <- split(seq(games_n), (seq(games_n) %/% (chunk_size)) + 1)

games_file <- file(pgn_file, "r")

daux <- data_frame(id = NA, event = NA, site = NA, date = NA, round = NA,
                   white = NA, black = NA, result = NA, blackelo = NA, whiteelo = NA,
                   eco = NA, movements = NA)

#### move al infomation to db! ####
l_ply(chunks, function(chunk){ # chunk <- sample(chunks, 1) 
  
  message("")
  
  games_chunk_df <- ldply(unlist(chunk), function(game_id){ # game_id <- sample(unlist(chunk), 1)
    
    game_str <- readLines(games_file, 1, encoding = "latin1")
    
    game_lst <- fromJSON(game_str)
    
    movements <- length(game_lst$fen)
    
    if (is.null(game_lst$BlackElo)) game_lst$BlackElo <- NA
    
    if (is.null(game_lst$WhiteElo)) game_lst$WhiteElo <- NA
    
    # getting positions and moving to db
    df_movements <- data.frame(game_id = rep(game_id,  movements),
                               movement = seq(movements),
                               fen = game_lst$fen,
                               pgn = c("", game_lst$pgn))
    
    dbWriteTable(conn = db, name = "movements_aux", df_movements, row.names = FALSE, append = TRUE)
    
    game_lst$pgn <- NULL
    
    game_lst$fen <- NULL
    
    game_df <- game_lst %>%
      as.data.frame() %>% 
      mutate(id = game_id, movements = movements) 
    
    names(game_df) <- tolower(names(game_df))
    
    game_df
    
    
  }, .progress = "text")
  
  games_chunk_df <- rbind.fill(daux, games_chunk_df)
  
  games_chunk_df <- games_chunk_df %>% filter(!is.na(movements))
  
  dbWriteTable(conn = db, name = "games", games_chunk_df, row.names = FALSE, append = TRUE)
  
}, .progress = "text")

# some checks
dbListTables(db)

# The columns in a table
dbListFields(db, "movements_aux")         

#### closing conecctions ####
dbDisconnect(db)
close(games_file)

