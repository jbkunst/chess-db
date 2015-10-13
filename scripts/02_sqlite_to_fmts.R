#### Packages ####
rm(list = ls())
library("plyr")
library("dplyr")
library("readr")


#### Parameters ####
PATH_TSV <- "data-tsv"
PATH_GZIP <- "data-gzip"
PATH_RDATA <- "data-rdata"
PATH_SQL <- "data-sqlite"
DB_NAME <- "db.sqlite"

DB_PATH <- file.path(PATH_SQL, DB_NAME) 

#### Folders ####
l_ply(c(PATH_TSV, PATH_RDATA, PATH_GZIP), function(x){
  unlink(x, recursive = TRUE)
  file.remove(x)
  dir.create(x)
})


#### Load Games table ####
chessdb <- src_sqlite(DB_PATH, create = FALSE)

games <- tbl(chessdb, "games") %>% collect()

str(games)


#### Export ####
l_ply(unique(games$eco), function(e){ e <- sample(unique(games$eco), size = 1)
  games_aux <- games %>% filter(eco == e)
  
  write.table(games_aux, file = file.path(PATH_TSV, sprintf("games_eco_%s.txt", e)),
              quote = FALSE, sep = "\t", row.names = FALSE)
  
  gz <- gzfile(file.path(PATH_GZIP,  sprintf("games_eco_%s.txt.gz", e)), "w")
  write.table(games_aux, file = gz, quote = FALSE, sep = "\t", row.names = FALSE)
  close(gz)
  
}, .progress = "text")

save(games, file = file.path(PATH_RDATA, "games.RData"))


#### Examples ####
int <- readLines("data-raw/KingBase2015-09-A00-A39.pgn", n = 30)
int <- int[seq(0, max(which(int == "")))]

out <- games %>% head(10)

writeLines(int, con = "example_input.pgn")
write.table(out, file = "example_output.tsv", quote = FALSE, sep = "\t", row.names = FALSE)
write_csv(out, "example_output.csv")



