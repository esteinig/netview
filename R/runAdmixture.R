#' runAdmixture
#' 
#' Convenience function for running Admixture.
#' 
#' @param filePath          Path to input files, either '.bed', '.ped' or '.geno' (see Admixture Manual)
#' @param K                 Range of K for Admixture [ int vector, 1:10]
#' @param processors        Number of processors for analysis [ int, 1 ]
#' @param crossValidation   Number of cross-validation error iterations [ int, 20 ]
#' @param plotValidation    Return plot of cross-validation error across runs [ bool, FALSE ] 
#' @param admixturePath     Path to admixture executable [ str, NULL ]        
#' 
#' @return K-named vector containing cross-validation errors or plot of cross-validation error across K.
#' 
#' @usage runAdmixture(filePath="/home/esteinig/admixture/butterflyfish.bed", K=1:10, processors=1, crossValidation=20, plotValidation=FALSE)
#' 
#' @details Admixture executable can be in $PATH. If this is not working, you can specify the full path to the executable in admixturePath. For examples and tutorials, please see our GitHub Repository: \url{https://github.com/esteinig/netview}

#' @export

runAdmixture <- function(filePath, K=1:10, processors=1, crossValidation=20, plotValidation=FALSE, admixturePath=NULL) {
  
  cross_error <- c()
  
  for (k in K) {
    
    if(is.null(admixturePath)){
      admixturePath <- "admixture"
    }
    
    print(paste0(admixturePath, ' ', '--cv=', crossValidation, ' ', '-j', processors, ' ', filePath, ' ', k))
    
    out <- system(paste0(admixturePath, ' ', '--cv=', crossValidation, ' ', '-j', processors, ' ', filePath, ' ', k), intern = T)
    
    print(out)
    
    cv <- getCV(out)
    
    cross_error <- append(cross_error, cv)
  } 
  
  names(cross_error) = K
  
  if (plotValidation==TRUE){
    
    require(ggplot2)
    
    df <- data.frame(K=names(cross_error), CVE=cross_error)
    
    p <- ggplot(data=df, aes(x=K, y=CVE)) + geom_line(aes(group=1)) + geom_point(size=3) +
      theme(legend.position="none", panel.grid.minor = element_blank()) +
      scale_x_discrete(limits=names(cross_error), labels=names(cross_error)) + ylab('Cross-Validation Error\n') + xlab('\nK')
    
    return(p) 
    
  } else {
    
    return(cross_error)
    
  }
  
}