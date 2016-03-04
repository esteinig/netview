# netview

mkNNG <- function(mdist=NULL, range.k=NULL, mst=FALSE, options=netview.getOptions() ) {
  
  # Construct mutual k-nearest-neighbour graph ( ?nng ) and optional edges 
  # from the minimum spanning tree ( ?minimum.spanning.tree ) using a symmetrical distance matrix.
  
  require(cccd)
  
  if(is.matrix(mdist)==F | nrow(mdist) != ncol(mdist) | is.null(mdist) )
    { stop('Input must be a symmetric distance matrix (N x N).') }
  
  weighted=options[['mknn.weights']]
  mknn.algorithm=options[['mknn.algorithm']]
  
  graphs <- list()
  
  for (i in range.k) { 
    
    require(cccd)
    
    # See original source code of SPC algorithm implemented in SPIN
    # Neuditschko et al. (2012)
    
    mknn_graph <- nng(mdist, k=i, mutual=T, algorithm=mknn.algorithm)
    
    V(mknn_graph)$name <- seq(length(V(mknn_graph)))
    
    mknn_graph$layout <- layout.fruchterman.reingold(mknn_graph)
    mknn_graph$dist <- mdist
    
    if (mst==TRUE){
      
      fc_graph <- graph.adjacency(mdist, mode=c('undirected'), weighted=TRUE)
      mst_graph <- minimum.spanning.tree(fc_graph)
      
      V(mst_graph)$name <- seq(length(V(mst_graph)))
      
      e <- ends(mst_graph, E(mst_graph))
      g <- mknn_graph + edge(as.vector(t(e)))
      g <- simplify(g)
      
    } else {
      
      g <- mknn_graph
      
    }
    
    if (weighted==TRUE) {
      
      e <- ends(g, E(g))
      E(g)$weight <- g$dist[e]
      
    }
    
    graphs[[paste0('k', as.character(i))]] <- g
  }
  
  return(graphs)
  
}
