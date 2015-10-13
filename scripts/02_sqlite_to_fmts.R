#### Packages ####
rm(list = ls())
library("plyr")
library("dplyr")
library("readr")


#### Parameters ####
PATH_TSV <- "data-tsv"
PATH_RDATA <- "data-rdata"
PATH_SQL <- "data-sqlite"
DB_NAME <- "db.sqlite"

DB_PATH <- file.path(PATH_SQL, DB_NAME) 

#### Folders ####
l_ply(c(PATH_TSV, PATH_RDATA), function(x){
  unlink(x, recursive = TRUE)
  file.remove(x)
  dir.create(x)
})


#### Load Games table ####
chessdb <- src_sqlite(DB_PATH, create = FALSE)

games <- tbl(chessdb, "games") %>% collect()

str(games)

games <- games %>% select(-id)

#### Export 1 ####
save(games, file = file.path(PATH_RDATA, "games.RData"))
write.table(games, file = file.path(PATH_TSV, "game.tsv"), quote = FALSE, sep = "\t", row.names = FALSE)



#### Export 2 ####
games <- games %>% select(-moves)

save(games, file = file.path(PATH_RDATA, "games_wo_moves.RData"))
write.table(games, file = file.path(PATH_TSV, "game_wo_moves.csv"), quote = FALSE, sep = "\t", row.names = FALSE)
