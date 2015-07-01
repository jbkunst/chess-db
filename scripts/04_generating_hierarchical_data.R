#### wksp & opts ####
rm(list = ls())
options(stringsAsFactors = FALSE)


#### packages ####
source("scripts/00_r_utils.R")
library("RSQLite")
library("DBI")
library("plyr")
library("dplyr")
library("tidyr")
library("jsonlite")


#### opening connections ####
db_path <- "data/KingBaseLite.sqlite3"

chessdb <- src_sqlite(db_path, create = FALSE)
chessdb

db <- dbConnect(SQLite(), dbname = db_path)
dbListTables(db)

#### Using tidyr's spread ####
deep <- 7

games <- tbl(chessdb, "games")

movements <- tbl(chessdb, "movements")

movements <- movements %>% select(-fen) %>% filter(movement <= deep) %>% collect()

movements_spread <- movements %>% spread(movement, pgn)

names(movements_spread)[-1] <- paste0("m", 1:deep)

movements_spread <- movements_spread %>%
  unite_("pgn", paste0("m", 1:deep), sep = " ", remove = FALSE)

movements_spread <- movements_spread %>% 
  mutate("m1" = "start")

movements_spread_group <- movements_spread %>% 
  group_by(pgn) %>% summarise(size = n()) %>% 
  arrange(desc(size)) %>% 
  plyr::join(., movements_spread, by = "pgn", match = "first") %>% 
  tbl_df() %>% 
  select(-game_id, -pgn)

movements_spread_group <- movements_spread_group %>%
  select(-size) %>%
  cbind(movements_spread_group %>% select(size)) %>% 
  tbl_df()

movements_hierarchy <- rsplit(movements_spread_group)

movements_json <- toJSON(movements_hierarchy[[1]], pretty = TRUE, auto_unbox = TRUE)

writeLines(movements_json, "../vizs/d3-zoomable-sunburst/test.json")
writeLines(movements_json, "../vizs/d3-icicle/test.json")
writeLines(movements_json, "../vizs/d3-cluster-dendrogram/test.json")

