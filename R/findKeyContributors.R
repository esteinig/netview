#'Identification of Key Contributors
#'
#'Identification of key contributors using Horn's Parallel Analysis, Eigenvalue Decomposition and
#'calculation of the Genetic Contribution Score (GCS) as described in Neuditschko et al. (2016).
#'
#'@param relMatrix             Pairwise relationship / similarity matrix between samples (N x N)
#'@param metaData              Data frame for NetView containing ID of individuals ordered as in the similarity matrix (N)
#'@param paranIterations       Iterations for computing the number of significant components using Horn's Parallel Analysis in Paran [ int, 100 ]
#'@param paran.centile         Significance level (centile used in estimating bias) in Paran [ int, 99 ]
#'@param distMatrix            Input matrix is a distance matrix; converted to similarity matrix by subtracting from 1 [ bool, FALSE ]
#'@param verbose               Print computation status and results of Horn's Parallel Analysis [ bool, TRUE ]

#'@usage findKeyContributors(relMatrix, metaData, paranIterations=100, paranCentile=99, distMatrix=FALSE, verbose=TRUE)
#'
#'@return Data frame containing ordered genetic contribution scores (GCS)
#'
#'@export

findKeyContributors <- function(relMatrix, metaData, paranIterations=100, paranCentile=99, distMatrix=FALSE, verbose=FALSE){
  
  require(paran)
  
  ### Written by Markus Neudtschko and Mehar Khatkar, modified * for use in NetView R by Eike Steinig
  
  if(distMatrix==TRUE){
    
    # If input is a distance matrix, convert to similarity - relationship matrix by
    # subtracting each element from 1 and setting diagonal to 1. *
    
    relMatrix = 1 - relMatrix
    diag(relMatrix) = rep(1, nrow(relMatrix))
    
  }
  
  # Set centile, from significance input (as stated in the publication) *
  
  # Added verbosity *
  
  if(verbose==FALSE){ quiet = TRUE; stat = FALSE } else { quiet = FALSE; stat = TRUE }
  
  k = paran(relMatrix, iterations=paranIterations, centile=paranCentile, quietly=quiet, status=stat)
  
  x = eigen(relMatrix)    
  
  vectors = x$vectors   
  values  = x$values    
  n       = length(values)
  D       = matrix(0, nrow =n, ncol=n)
  diag(D) = values
  
  # Modified access to number of significant - retained PCs by k$Retained *
  k = k$Retained                     
  RSV   = vector("list",n) 
  scores = vector("list",n)
  
  for (i in 1:n)
  {
    RSV[[i]] = solve(sqrt(D[1:k,1:k])) %*% t(vectors[,1:k]) %*% relMatrix[,i]
    scores[[i]] = sum(RSV[[i]]^2)
  }
  
  scores   = as.data.frame (unlist(scores))
  names(scores) = "gcs"
  y = as.data.frame(scores)
  
  # Modified names of gcs_score variable and access to meta data column 'ID', removed sample Number *
  id = metaData$ID
  gcs_scores = cbind(id, y)
  
  # Modified column headers of data frame with GCS *
  names(gcs_scores) = c("ID","GCS")
  
  return(gcs_scores)
  
}