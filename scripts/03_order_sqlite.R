#### wksp & opts ####
rm(list = ls())
options(stringsAsFactors = FALSE)


#### packages ####
library("RSQLite")
library("DBI")
library("plyr")
library("dplyr")


#### opening connections ####
db_path <- "data/KingBaseLite.sqlite3"

chessdb <- src_sqlite(db_path, create = FALSE)
chessdb

db <- dbConnect(SQLite(), dbname = db_path)
dbListTables(db)

#### creating id for tables and positions ####
games <- tbl(chessdb, "games")

games

games %>% group_by(eco) %>% summarise(n = n()) %>% arrange(desc(n))

movements <- tbl(chessdb, "movements")

movements %>% filter(movement == 2) %>% group_by(pgn) %>% summarise(n = n()) %>% arrange(desc(n))
movements %>% filter(movement == 2) %>% group_by(pgn) %>% summarise(n = n()) %>% compute() %>% nrow()

movements %>% compute() %>% nrow()
movements %>% select(fen) %>% distinct() %>% compute() %>% nrow()


games %>% filter(id == 1)
movements %>% filter(game_id == 1) %>% compute()

# check!
check <- movements %>%
  group_by(game_id) %>%
  summarize(movements_position = n()) %>%
  rename(id = game_id) %>% 
  left_join(games, by = "id") %>%
  select(id, movements_position, movements) %>% 
  mutate(diff = movements_position - movements) %>% 
  group_by(diff) %>% 
  summarize(n = n()) %>% 
  arrange(desc(n))
check
# show_query(check)
