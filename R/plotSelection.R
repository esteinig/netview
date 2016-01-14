#' Selection k-Plot
#' 
#' Generates plot showing the number of detected communities against the parameter k for mutual k-nearest-neighbour graphs from NetView.
#' 
#' @param graphs            List of graphs decorated with community-detection results from NetView.
#' @param options           Options for NetView via netviewOptions [ list, netviewOptons() ]
#' 
#' @return List of community data (Data) and plot (Plot).
#' 
#' @usage plotSelection(graphs, options=netviewOptions() )
#' 
#' @details For examples and tutorials, please see our GitHub Repository: \url{https://github.com/esteinig/netview}
#'      
#' @export

plotSelection <- function(graphs, options=netviewOptions() ) {
  
  community_dir <- list(
    
    'Edge Betweenness' = 'edge_betweenness',
    'Fast-Greedy'= 'fast_greedy',
    'Infomap' = 'infomap',
    'Label Propagation' = 'label_propagation',
    'Leading Eigenvector' = 'leading_eigenvector',
    'Louvain' = 'louvain',
    'Walktrap' = 'walktrap'
    
  )
  
  require(igraph)
  require(ggplot2)
  
  algorithms <- options[["community.algorithms"]]
  
  # Analyze community clustering results for range of k and selected Algorithms
  
  k_range <- sapply(graphs, function(g) { return(g$k) })
  
  alg_data <- lapply(algorithms, function(x) {
    
    rows <- sapply(graphs, function(g) {
      
      alg <- community_dir[[x]]
      
      c <- get.graph.attribute(g, alg)
      
      #m <- modularity(c)
      
      n <- length(sizes(c))
      
      row <- c(x, g$k, n)
      
      return(row)
      
    })
    
    return(t(rows))
    
  })
  
  
  m <- do.call(rbind, alg_data)
  df <- as.data.frame(m)
  rownames(df) <- NULL
  
  names(df) <- c('Algorithm', 'k', 'n')
  
  break_x <- seq(min(k_range), max(k_range), by=options[["selection.plot"]][1])
  
  x_range = seq(1, max(k_range), by=1)
  y_range <- seq(1, max(as.numeric(as.character(df[['n']]))), by=1)
  
  break_y <- seq(0, max(y_range), by=options[["selection.plot"]][2])
  
  if (min(k_range) == 1 && options[["selection.plot"]][1] > 1) {
    
    break_x <- break_x-1
    break_x <- append(break_x, max(k_range))
  }
  
  p <- ggplot(df, aes(x=k, y=n, group=Algorithm)) +
    geom_line(aes(color=Algorithm), size=options[["selection.plot"]][3])+
    labs(title = options[["selection.title"]], x = "\nk", y = "n\n") +
    theme(axis.text.x = element_text(vjust=0.5), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
          panel.background = element_blank(), axis.line = element_line(colour = "black"), plot.title = element_text(face="bold")) +
    scale_x_discrete(limits=x_range, breaks=break_x) +
    scale_y_discrete(limits=y_range, breaks=break_y)
  
  results <- list("Data" = df, "Plot" = p)
  
  return(results)
  
}