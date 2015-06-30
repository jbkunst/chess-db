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

####
deep <- 5

movements <- tbl(chessdb, "movements")


mv1 <- movements %>% filter(movement == 1) %>%  group_by(pgn) %>% summarize(n = n()) %>% arrange(desc(n))
mv2 <- movements %>% filter(movement == 2) %>%  group_by(pgn) %>% summarize(n = n()) %>% arrange(desc(n))

nrow(compute(mv2))
