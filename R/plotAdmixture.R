#' Admixture Plots
#' 
#' Generate admixture graphs for NetView or plot admixture proportions with Structure Plot.
#' 
#' @param outFile           Zipped output from Admixture containing original files: .Q and .P
#' @param metaData          Data frame with meta data as for NetView; required columns 'ID', 'Group' and 'Colour'.
#' @param K                 Plot admixture proportions at selected number of clusters K
#' @param graph             Network object iGraph for generating Admixture Graph [ graph, NULL ]
#' @param structurePlot     Generate admixture proportion bar plot using Structure Plot [ bool, TRUE ]
#' @param palette           Colour palette from RColorBrewer clusters K [ str, "Dark2" ]
#' @param pn                Number of colours to include in palette, see RColorBrewer [ int, 8 ]
#' 
#' @return Graph object with data for plotting admixture proportions or bar plot from Structure Plot.
#' 
#' @usage plotAdmixture("oyster_output.zip", oysterData, K=4, ...)
#' @details For examples and tutorials, please see our GitHub Repository: \url{https://github.com/esteinig/netview}
#' 
#' @export

plotAdmixture <- function(outFile, metaData, K, graph=NULL, structurePlot=TRUE, palette="Dark2", pn = 8) {
  
  require(RColorBrewer)
  require(igraph)
  require(reshape2)
  
  if (is.character(palette) && length(palette) == 1){
    
    colours <- colorRampPalette(brewer.pal(pn, palette))(K)
    
  } else {
    
    if (length(palette) == K){
      colours <- palette
    } else { 
      error("Palette is not of length K.")
    }
    
  }
  
  qFiles <- readArchive(metaData, outFile)
  
  valuesK <- as.numeric(names(qFiles))
  
  if (structurePlot==FALSE){
    p <- makeAdmixtureGraph(qFiles, colours, graph, K)
  } 
  else {
    p <- makeStructurePlot(colours, qFiles, K)
  }
  return(p)
}