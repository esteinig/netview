netviewErrorCheck <- function(distMatrix, metaData, options){
  
  if (nrow(distMatrix) != nrow(metaData)){
    stop("Distance matrix and data frame must contain the same number of samples (N) [Error 1]")
  }
  
  if (!is.matrix(distMatrix)){
    stop("Input is not a matrix [Error 6]")
  }
  
  if (!is.data.frame(metaData)){
    stop("Input is not a data frame [Error 7]")
  }
  
  if (dim(distMatrix)[1] != dim(distMatrix)[2]){
    stop("Distance matrix needs to be symmetrical (N x N) [Error 2]")
  }
  
  if (!options[["nodeID"]] %in% names(metaData)){
    stop(paste("Data frame does not contain ID column:", options[["nodeID"]], "[Error 3]"))
  }
  
  if (!options[["nodeGroup"]] %in% names(metaData)){
    stop(paste("Data frame does not contain group column:", options[["nodeGroup"]], "[Error 4]"))
  }
  
  if (!options[["nodeColour"]] %in% names(metaData)){
    stop(paste("Data frame does not contain colour column:", options[["nodeColour"]], "[Error 5]"))
  }
  
  if (!is.element(options[["mknn.algorithm"]], c("cover_tree", "kd_tree", "CR", "brute"))){
    stop("Algorithm for mutual k-nearest neighbour search has to be one of: 'cover_tree', 'kd_tree', 'CR', 'brute' [Error 8]")
  }
  
  for (e in options[["community.algorithms"]]){
    if (!is.element(e, c("Walktrap", "Infomap", "Fast-Greedy", "Edge Betweenness", "Label Propagation", "Louvain", "Leading Eigenvector"))){
      stop(paste(e, 'is not supported. Allowed algorithms for community detection are: "Walktrap", "Infomap", "Fast-Greedy", "Edge Betweenness", "Label Propagation", "Louvain", "Leading Eigenvector" [Error 9]'))
    }
  }
  
  if (!length(options[["selection.plot"]]) == 3){
    stop("Selection plot options must be a vector of length 3 [Error 10]")
  }
  
}