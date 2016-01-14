makeNetworkD3 <- function(g=NULL, data=NULL, options=NULL) {
  
  require(gplots)
  
  links <- get.edgelist(g)
  links <- links - 1
  
  if(is.null(E(g)$weight)){
    E(g)$weight <- rep(1, ecount(g))
  }
  
  links <- data.frame(Source=links[,1], Target=links[,2], Value=E(g)$weight*options[['d3.linkX']])
  
  if(is.null(options[['d3.colourScale']])){
    
    colours <- col2hex(unique(data[[ options[['nodeColour']] ]]))
    
    d3.colour.js <- "d3.scale.ordinal().range(["
    
    for (i in seq_along(colours)){
      d3.colour.js <- paste0(d3.colour.js,"\"", colours[i], "\"", ',')
    }
    
    d3.colour.js <- substr(d3.colour.js, 1, nchar(d3.colour.js)-1)
    d3.colour.js <- paste0(d3.colour.js, '])')
    nodeColour <- JS(d3.colour.js)
    
    
  } else {
    
    nodeColour <- options[['d3.colourScale']]
    
  }
  
  if (!options[["d3.nodeSize"]] %in% names(data)){
    
    data[[options[["d3.nodeSize"]]]] <- rep(1, nrow(data))
    
  }
  
  network <- forceNetwork(
     Links=links,
     Nodes=data,
     Source='Source',
     Target='Target',
     Value='Value',
     NodeID=options[['nodeID']],
     Nodesize=options[['d3.nodeSize']],
     Group=options[['nodeGroup']],
     height = options[['d3.height']],
     width = options[['d3.width']],
     colourScale = nodeColour,
     fontSize = options[['d3.fontSize']],
     fontFamily = options[['d3.fontFamily']],
     linkDistance = options[['d3.linkDistance']],
     linkWidth = options[['d3.linkWidth']],
     radiusCalculation = options[['d3.radiusCalculation']],
     charge = options[['d3.charge']],
     linkColour = options[['d3.linkColour']],
     opacity = options[['d3.opacity']],
     zoom = options[['d3.zoom']],
     legend = options[['d3.legend']],
     bounded = options[['d3.bounded']],
     opacityNoHover = options[['d3.opacityNoHover']],
     clickAction = options[['d3.clickAction']])
  
  return(network)
    
}