#### wksp & opts
rm(list = ls())
options(stringsAsFactors = FALSE)



#### packages
library("RSQLite")
library("DBI")
library("jsonlite")
library("stringi")
library("plyr")
library("dplyr")
library("magrittr")



#### parameters
pgn_file <- "data/sample.json"
sqlite_db <- "data/chessdb.sqlite3"
chunk_size <- 100 # games per chunk



#### creating db and load files

# remove if exist!
file.remove(sqlite_db)

db <- dbConnect(SQLite(), dbname = sqlite_db)

games_n <- as.numeric(strsplit(system(paste("wc -l", pgn_file), intern = TRUE), " ")[[1]][1])

chunks <- split(seq(games_n), (seq(games_n) %/% (chunk_size)) + 1)

games_file <- file(pgn_file, "r")



#### move al infomation to db! ####
l_ply(chunks, function(chunk){ # chunk <- sample(chunks, 1) 
 
  message("chunk: ", names(chunk))
   
  games_chunk_df <- ldply(unlist(chunk), function(game_id){ # game_id <- sample(unlist(chunk), 1)
    
    game_str <- readLines(games_file, 1, encoding = "latin1")
    
    game_lst <- fromJSON(game_str)
    
    movements <- length(game_lst$fen)
    
    # getting positions and moving to db
    df_positions <- data.frame(game_id = rep(game_id,  movements),
                               position = seq(movements),
                               fen = game_lst$fen,
                               pgn = c("", game_lst$pgn))
    
    dbWriteTable(conn = db, name = "position", df_positions, row.names = FALSE, append = TRUE)
    
    game_lst$pgn <- NULL
    game_lst$fen <- NULL
    
    game_df <- game_lst %>%
      as.data.frame() %>% 
      mutate(id = game_id, movements = movements) 
    
    game_df
    
  }, .progress = "text")
  
  dbWriteTable(conn = db, name = "game", games_chunk_df, row.names = FALSE, append = TRUE)
   
}, .progress = "text")

# some checks
dbListTables(db)

# The columns in a table
dbListFields(db, "position")         

dbDisconnect(db)

rm(chunks, chunk_size, db, games_n, pgn_file, sqlite_db, games_file)


#### checks using dplyr
chessdb <- src_sqlite("data/chessdb.sqlite3", create = FALSE)

tbl_game <- tbl(chessdb, "game")
tbl_position <- tbl(chessdb, "position")


tbl_game %>% group_by(ECO) %>% summarize(n = n()) %>%  arrange(desc(n))
tbl_game %>% group_by(Date) %>% summarize(n = n()) %>%  arrange(desc(n))

# check!
tlb_counts <- tbl_position %>%
  group_by(game_id) %>%
  summarize(movements_position = n()) %>%
  rename(id = game_id)



tbl_check <- left_join(tbl_game, tlb_counts, by = "id") %>%
  select(movements_position, movements, id)

tbl_position
tbl_position_counts <- tbl_position %>%
  group_by(fen) %>% 
  summarize(n = n()) %>% 
  arrange(desc(n))

local <- collect(tbl_position_counts) %>% 
  arrange(desc(n))
