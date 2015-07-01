#### wksp & opts ####
rm(list = ls())
options(stringsAsFactors = FALSE)


#### packages ####
library("RSQLite")
library("DBI")
library("plyr")
library("dplyr")
library("tidyr")


#### opening connections ####
db_path <- "data/KingBaseLite.sqlite3"

chessdb <- src_sqlite(db_path, create = FALSE)
chessdb

db <- dbConnect(SQLite(), dbname = db_path)
dbListTables(db)

#### Using tidyr's spread ####
deep <- 5

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




rsplit <- function(x) {
  
  x <- x[!is.na(x[,1]),,drop=FALSE]
  
  if(nrow(x)==0) return(NULL)
  
  if(ncol(x)==2) {
    return(x)
  }
  
  s <- split(x[,-1, drop=FALSE], x[,1])
  
  unname(mapply(function(v,n) {
    if(!is.null(v)) {
      list(name = n , children=v)
    } else {
      list(name=n)
    }
  }, lapply(s, rsplit), names(s), SIMPLIFY=FALSE))
}


jotason <- rsplit(movements_spread_group)

jotason2 <- jsonlite::toJSON(jotason, pretty = TRUE, auto_unbox = TRUE)

writeLines(jotason2, "../vizs/d3-coffe-wheel-sunburst/test.json")

jotason <- rsplit(movements_spread_group)

jotason2 <- jsonlite::toJSON(jotason[[1]], pretty = TRUE, auto_unbox = TRUE)

writeLines(jotason2, "../vizs/d3-zoomable-sunburst/test.json")

