#' NetView R
#' 
#' Generate mutual nearest-neighbour graphs for population analysis and visualization with iGraph and networkD3.
#' 
#' @param distMatrix  Symmetrical distance matrix for NetView (N x N)
#' @param metaData    Data frame with meta data for each sample (N), ordered as samples in distMatrix; required columns 'ID', 'Group' and 'Colour'
#' @param tree        Rooted phylogeny for construction of a cophenetic distance matrix [ phylo, NULL ]
#' @param k           Range of parameter k for mutual k-nearest-neighbour search [ vector of integers, 10:60 ]
#' @param cluster     Decorate graph objects with the results of community detection analyses, configure via netviewOptions [ bool, FALSE ]
#' @param mst         Include edges of the minimum spanning tree associated with the data [ bool, FALSE ]
#' @param networkD3   Return networks visualizations with networkD3, configure via netviewOptions [ bool, FALSE ]
#' @param save        Save graphs as GML or visualizations with networkD3 as HTML [ bool, FALSE ]
#' @param project     Project directory for saving graphs and networkD3 [ str, 'netview' ] 
#' @param options     Options from netviewOptions() [ list, netviewOptions() ]
#' 
#' @return List of graph objects or widgets from networkD3.
#' 
#' @usage netview(distMatrix, metaData, k=1:60, cluster=TRUE, ...)
#' @details For examples and tutorials, please see our GitHub Repository: \url{https://github.com/esteinig/netview}
#' 
#' @export
#' @import igraph
#' @import cccd
#' @importFrom htmlwidgets saveWidget
#' @import networkD3
#' @importFrom ape cophenetic.phylo
#' @import gplots
#' @import ggplot2
#' @import reshape2
#' @import RColorBrewer

netview <- function(distMatrix=NULL, metaData=NULL, tree=NULL, k=10:60, cluster=FALSE, mst=FALSE, networkD3=FALSE,
                    save=FALSE, project='netview', options=netviewOptions()){
  
  require(igraph)
  require(cccd)
  require(networkD3)
  require(htmlwidgets)
  require(ape)
  require(gplots)
  
  if(is.null(metaData)){
    stop("Data frame not specified, please provide sample metaData.")
  }
  
  if(is.null(distMatrix) & is.null(tree)){
    stop("Input data not specified, please provide a distance matrix or rooted phylogeny.")
  }

  netviewErrorCheck(distMatrix, metaData, options)
  
  if(!is.null(tree)){
    
    # Order cophenetic matrix and data:
    metaData <- metaData[order(metaData$ID),] 
    dist <- cophenetic.phylo(tree)
    distMatrix <- dist[order(rownames(dist)), order(colnames(dist))]
    
  }
  
  # Construct mkNNGs
  graphs <- mkNNG(mdist=distMatrix, range.k=k, mst=mst, options=options)
  
  # Construct networkD3
  if(networkD3==T){
    
    graphs <- lapply(graphs, function(g) {
      
      network <- makeNetworkD3(g, metaData, options=options)
      
    })
    
  } else {
    
    # If not networkD3, decorate graphs with Data
    graphs <- lapply(graphs, function(g) {
      
      V(g)$color <- as.character(metaData[[options[["nodeColour"]]]])
      V(g)$id <- as.character(metaData[[options[["nodeID"]]]])
      V(g)$group <- as.character(metaData[[options[["nodeGroup"]]]])
      
      return(g)
      
    })
    
    if (cluster == TRUE) {
      graphs <- findCommunities(graphs, options)
    }
    
  }
  
  if(save == TRUE){ 
    saveNetview(graphs=graphs, project=project, networkD3=networkD3, options=options)
    }
  
  return(graphs)
  
}