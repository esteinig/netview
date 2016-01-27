findCommunities <- function(networks, options) {
  
  algorithms <- options[["community.algorithms"]]
  
  for (algorithm in algorithms) {
    networks <- lapply(networks, function(g) {
      
      if (algorithm == 'Walktrap') {
        
        # Walktrap Algorithm
        # Default: weights = E(g)$weight, steps = 4, merges = T, modularity = T, membership = T
        # Change to step selection in UI
        # http://igraph.org/r/doc/cluster_walktrap.html
        
        walktrap <- cluster_walktrap(g)
        g$walktrap <- walktrap
        
        
      } else if (algorithm=='Fast-Greedy') {
        
        # Fast-Greedy
        # Default: merges = T, modularity = T, memberships = T, weights = E(g)$weight
        # http://igraph.org/r/doc/cluster_fast_greedy.html
        
        fast_greedy <- cluster_fast_greedy(g)
        g$fast_greedy <- fast_greedy
        
      } else if (algorithm=='Infomap') {
        
        # Infomap
        # Default: e.weights = E(g)$weight, v.weights = NULL, nb.trials = 10, modularity = T
        # Change to manual selection of nb.trials in UI
        # http://igraph.org/r/doc/cluster_infomap.html
        
        infomap <- cluster_infomap(g)
        g$infomap <- infomap
        
      } else if (algorithm=='Edge Betweenness') {
        
        # Edge Betweenness
        # Default: weights = E(graph)$weight, directed = FALSE,
        # edge.betweenness = TRUE, merges = TRUE, bridges = TRUE,
        # modularity = TRUE, membership = TRUE
        # http://igraph.org/r/doc/cluster_edge_betweenness.html
        
        edge_betweenness <- cluster_edge_betweenness(g, directed=FALSE)
        g$edge_betweenness <- edge_betweenness
        
      } else if (algorithm=='Label Propagation') {
        
        # Label Propagation
        # Defauts: weights = NULL, initial = NULL, fixed = NULL
        # http://igraph.org/r/doc/cluster_label_prop.html
        
        label_propagation <- cluster_label_prop(g)
        g$label_propagation <- label_propagation
        
      } else if (algorithm=='Leading Eigenvector') {
        
        # Leading Eigenvector
        # Defaults: graph, steps = -1, weights = NULL, start = NULL,
        # options = arpack_defaults, callback = NULL, extra = NULL,
        # env = parent.frame()
        # http://igraph.org/r/doc/cluster_leading_eigen.html
        
        leading_eigenvector <- cluster_leading_eigen(g)
        g$leading_eigenvector <- leading_eigenvector
        
      } else if (algorithm=='Louvain') {
        
        # Louvain
        # Defaults: weights = NULL
        # http://igraph.org/r/doc/cluster_louvain.html
        
        louvain <- cluster_louvain(g)
        g$louvain <- louvain
        
      }
      return(g)
    })
    
  }
  
  return(networks)
}
