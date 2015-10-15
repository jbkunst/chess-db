source("scripts/01_pgn_to_sqlite.R")
source("scripts/02_sqlite_to_fmts.R")


library("dplyr")
load("data-rdata/games.RData")

df_magnus <- games %>%
  filter(white == "Carlsen, Magnus")


readr::write_csv(df_magnus, "data-sandbox/chess_magnus.csv")

