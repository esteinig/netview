#' Admixture Cross-Validation Error
#' 
#' Convenience function for plotting the cross-validation error output from Admixture.
#' 
#' @param crossError  List of cross-validation error values from Admixture, names designate K.
#' 
#' @return Cross-validation error plot for output from Admixture.
#' 
#' @usage plotValidation(crossError)
#' 
#' @details For examples and tutorials, please see our GitHub Repository: \url{https://github.com/esteinig/netview}
#'      
#' @export

plotValidation <- function(crossError) {
  
  require(ggplot2)
  
  df <- data.frame(K=names(crossError), CVE=crossError)

  p <- ggplot(data=df, aes(x=K, y=CVE)) + geom_line(aes(group=1)) + geom_point(size=3) +
    theme(legend.position="none", panel.grid.minor = element_blank()) +
    scale_x_discrete(limits=names(crossError), labels=names(crossError)) + ylab('Cross-Validation Error\n') + xlab('\nK')
  
  return(p)
  
}