#### wksp & opts ####
rm(list = ls())
options(stringsAsFactors = FALSE)


#### packages ####
library("RSQLite")
library("DBI")
library("plyr")
library("dplyr")


#### opening connections ####
db_path <- "data/chessdb.sqlite3"

chessdb <- src_sqlite(db_path, create = FALSE)
chessdb

db <- dbConnect(SQLite(), dbname = db_path)
dbListTables(db)

#### creating id for tables and positions ####
games <- tbl(chessdb, "games")

games

games %>% group_by(eco) %>% summarise(n = n()) %>% arrange(desc(n))

movements_aux <- tbl(chessdb, "movements_aux")

movements_aux %>% filter(movement == 2) %>% group_by(pgn) %>% summarise(n = n()) %>% arrange(desc(n))
movements_aux %>% filter(movement == 2) %>% group_by(pgn) %>% summarise(n = n()) %>% compute() %>% nrow()

movements_aux %>% compute() %>% nrow()
movements_aux %>% select(fen) %>% distinct() %>% compute() %>% nrow()


games %>% filter(id == 1)
movements_aux %>% filter(game_id == 1) %>% compute()

# check!
check <- movements_aux %>%
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
compute(check)
# dbRemoveTable(db, "tbl_check")
# compute(tbl_check, "tbl_check", temporary = TRUE)

# dbRemoveTable(db, "fens_aux")
fens_aux <- movements_aux %>% 
  group_by(fen) %>% 
  summarise() %>% 
  compute("fens_aux", temporary = TRUE)

# dbRemoveTable(db, "fens")

dbGetQuery(db, "select * from fens limit 10")


dbGetQuery(db, "alter table fens add column id3 integer auto_increment not null")


dbGetQuery(db, "select * from fens limit 10")

dbGetQuery(db, "create table fens2(id integer primary key, fen text)")
dbGetQuery(db, "insert into fens2 (fen) select fen from fens")

dbGetQuery(db, "select * from fens2 limit 10")

