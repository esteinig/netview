makeAdmixtureGraph <- function(qDF, colours, graph) {
  
  dm <- as.matrix(qDF)
  
  values <- lapply(seq(1, vcount(graph), 1), function(x) { 
    row <- dm[x,]
    row <- as.numeric(format(row, scientific=F))
    return(row)
  })
  
  V(graph)$pie.color <- list(colours)
  
  graph$pie.values <- values
  
  return(graph)
  
}