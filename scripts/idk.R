rm(list = ls())
library("magrittr")
library("plyr")
library("dplyr")
library("rchess")
library("stringr")

fls <- dir("data/", pattern = ".*pgn$", full.names = TRUE)
fls


dir.create("data_pgn")

games <- ldply(fls, function(f){ # f <- "data/KingBaseLite2015-05-B20-B49.pgn"
  print(f)
  flines <- readLines(f)
  if (length(flines) < 2 ) {
    return(0)
  }
  
  where_is_no_info <- which(str_length(flines) == 0)
  where_is_no_info <- where_is_no_info[seq(length(where_is_no_info)) %% 2 == 0]
  where_is_no_info <- c(0, where_is_no_info)
  
  dfcuts <- data_frame(from = head(where_is_no_info, -1) + 1,
                       to = tail(where_is_no_info, -1) - 1)
  
  nrow(dfcuts)
  
})

padwidth <- nchar(max(games))
rm(games)


llply(fls, function(f){ # f <- "data/KingBaseLite2015-05-B20-B49.pgn"
  
  print(f)
  
  flines <- readLines(f)
  
  if (length(flines) < 2 ) return(FALSE)
  
  where_is_no_info <- which(str_length(flines) == 0)
  where_is_no_info <- where_is_no_info[seq(length(where_is_no_info)) %% 2 == 0]
  where_is_no_info <- c(0, where_is_no_info)
  
  dfcuts <- data_frame(from = head(where_is_no_info, -1) + 1,
                       to = tail(where_is_no_info, -1) - 1)
  
  f2 <- str_replace_all(basename(f), "KingBaseLite2015-05-|\\.pgn", "")
  
  for (row in seq(nrow(dfcuts))) { # row <- 50000
    if (row %% 10000 == 0) {
      message( row/nrow(dfcuts) * 100)
    }
    
    if (row > 100) {
      return(FALSE)
    }
    
    writeLines(flines[seq(dfcuts[row, ]$from, dfcuts[row, ]$to)],
               con = sprintf("data_pgn/%s_%s.pgn",
                             f2,
                             str_pad(row, width = padwidth, pad = "0")))
  }
  
  TRUE

}, .progress = "text")

