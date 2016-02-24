#' Admixture Plots
#' 
#' Generate admixture graphs for NetView or plot admixture proportions with Structure Plot.
#' 
#' @param qFile             Output file for ancestry proportions from Admixture (.Q)
#' @param metaData          Data frame with meta data as for NetView; required columns 'ID', 'Group' and 'Colour'
#' @param graph             Network object iGraph for generating Admixture Graph [ graph, NULL ]
#' @param structurePlot     Generate admixture proportion bar plot using Structure Plot [ bool, TRUE ]
#' @param palette           Colour palette from RColorBrewer or vector of colours (length K) [ str, "Dark2" ]
#' @param colourN           Number of colours to include in palette, see RColorBrewer [ int, 8 ]
#' 
#' @return Graph object with data for plotting admixture proportions or bar plot from Structure Plot.
#' 
#' @usage plotAdmixture(qFile="oyster.4.Q", metaData=oysterData, graph=NULL, structurePlot=T, palette="Dark2", colourN=8)
#' @details For examples and tutorials, please see our GitHub Repository: \url{https://github.com/esteinig/netview}
#' 
#' @export

plotAdmixture <- function(qFile, metaData, graph=NULL, options=netviewOptions(), structurePlot=TRUE, palette="Dark2", colourN = 8) {
  
  require(RColorBrewer)
  
  qDF <- as.data.frame(read.table(qFile, header=F, sep=' ', colClasses = "numeric"))
  
  K <- ncol(qDF)
  
  if (is.character(palette) && length(palette) == 1){
    
    colours <- colorRampPalette(brewer.pal(colourN, palette))(K)
    
  } else {
    
    if (length(palette) == K){
      colours <- palette
    } else { 
      error("Palette is not of length K.")
    }
    
  }
  
  if (structurePlot==FALSE){
    require(igraph)
    p <- makeAdmixtureGraph(qDF, colours, graph)
  } 
  else {
    require(reshape2)
    p <- makeStructurePlot(qDF, metaData, colours, options)
  }
  return(p)
}