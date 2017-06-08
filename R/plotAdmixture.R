#' Admixture Plots
#' 
#' Generate admixture graphs for NetView or plot admixture proportions with Structure Plot.
#' 
#' @param qFile             Output file for ancestry proportions from Admixture (.Q), can also be DF
#' @param metaData          Data frame with meta data as for NetView; required columns 'ID', 'Group' and 'Colour'
#' @param graph             Network object iGraph for generating Admixture Graph [ graph, NULL ]
#' @param options           NetView options for specification of columns in metaData [ netviewOptions() ]
#' @param palette           Colour palette from RColorBrewer or vector of colours (length K) [ str, "Dark2" ]
#' @param colourN           Number of colours to include in palette, see RColorBrewer [ int, 8 ]
#' @param structurePlot     Generate admixture proportion bar plot using Structure Plot [ bool, TRUE ]
#' @param save              Name of to save ancestry file in working directory with column ID for input to Cytoscape [ str, NULL ]
#' @param sep				Seperator in Q file [ str, " " ]
#' 
#' @return Graph object with data for plotting admixture proportions or bar plot from Structure Plot.
#' 
#' @usage plotAdmixture(qFile="oyster.4.Q", metaData=oysterData, graph=NULL, palette="Dark2", colourN=8, structurePlot=TRUE, save=FALSE)
#' @details For examples and tutorials, please see our GitHub Repository: \url{https://github.com/esteinig/netview}
#' 
#' @export

plotAdmixture <- function(qFile, metaData, graph=NULL, options=netviewOptions(), sep=" ", palette="Dark2", colourN = 8, structurePlot=TRUE, save=NULL) {
  
  require(RColorBrewer)
  
  if (!is.data.frame(qFile)){
  
	qDF <- as.data.frame(read.table(qFile, header=F, sep=sep, colClasses = "numeric"))
  
  } else {
  
	qDF <- qFile
  
  }

  
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
  
  if (!is.null(save)){
    qDF <- cbind(metaData[[options[["nodeID"]]]], qDF)
    names(qDF)[1] <- "ID"
    write.csv(qDF, save, quote=FALSE, row.names=FALSE)
  }
  
  return(p)
}