# http://stackoverflow.com/questions/30734572/convert-a-data-frame-to-a-treenetwork-compatible-list?lq=1
# thanks to MrFlick

# I add some tweaks to in the case ncol(x) == 2
rsplit <- function(x) {
  
  x <- x[!is.na(x[,1]), , drop = FALSE]
  
  if (nrow(x) == 0) return(NULL)
  
  if (ncol(x) == 2) {
    names(x)[1] <- "name"
    return(x)
  }
  
  s <- split(x[,-1, drop = FALSE], x[,1])
  
  unname(mapply(function(v,n) {
    if (!is.null(v)) {
      list(name = n , children = v)
    } else {
      list(name = n)
    }
  }, lapply(s, rsplit), names(s), SIMPLIFY = FALSE))
}

