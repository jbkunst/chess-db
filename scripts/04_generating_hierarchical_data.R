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
  select(-game_id)


msgm <- movements_spread_group %>% select(-pgn, -size) %>% arrange_(names(.))





rsplit <- function(x) {
  
  x <- x[!is.na(x[,1]),,drop=FALSE]
  
  if(nrow(x)==0) return(NULL)
  
  if(ncol(x)==1) return(lapply(x[,1], function(v) list(name=v)))
  
  s <- split(x[,-1, drop=FALSE], x[,1])
  
  unname(mapply(function(v,n) {
    if(!is.null(v)) {
      list(name=n, children=v)
    } else {
      list(name=n)
    }
  }, lapply(s, rsplit), names(s), SIMPLIFY=FALSE))
}

rsplit(msgm)

toJSON(rsplit(msgm))

