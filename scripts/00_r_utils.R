# http://stackoverflow.com/questions/30734572/convert-a-data-frame-to-a-treenetwork-compatible-list?lq=1
# thanks to MrFlick

# I add some tweaks to in the case ncol(x) == 2
rsplit <- function(x) {
  
  x <- x[!is.na(x[, 1]), , drop = FALSE]
  
  if (nrow(x) == 0) 
    return(NULL)
  
  if (ncol(x) == 2) {
    names(x)[1] <- "name"
    return(x)
  }
  
  s <- split(x[, -1, drop = FALSE], x[, 1])
  
  unname(mapply(function(v, n) {
    if (!is.null(v)) {
      list(name = n, children = v)
    } else {
      list(name = n)
    }
  }, lapply(s, rsplit), names(s), SIMPLIFY = FALSE))
}

# http://stackoverflow.com/questions/12818864/how-to-write-to-json-with-children-from-r
makeList <- function(x) {
  if (ncol(x) > 2) {
    listSplit <- split(x[-1], x[1], drop = T)
    lapply(names(listSplit), function(y) {
      list(name = y, children = makeList(listSplit[[y]]))
    })
  } else {
    lapply(seq(nrow(x[1])), function(y) {
      list(name = x[, 1][y], Percentage = x[, 2][y])
    })
  }
}

