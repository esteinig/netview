#' NetView Options
#' 
#' Generate options for NetView.
#' 
#' @param mknnWeights           Construct networks with weighted edges, using the distance value from the input matrix [ bool, TRUE ]
#' @param mknnAlgorithm         Algorithm for mutual nearest neighbour search [ str, "cover_tree" ]
#' @param communityAlgorithms   Algorithms for community detection analysis [ str vector, c("Walktrap", "Infomap", "Fast-Greedy") ]
#' @param selectionTitle        Title for community k-Plot in plotSelection() [ str, "Community k-Plot"]
#' @param selectionPlot         Configure x- and y-axis breaks and line width of k-Plot [ int vector, c(5, 20, 1) ] 
#' @param nodeID                Name of column in metaData defining IDs [ str, "ID" ]
#' @param nodeGroup             Name of column in metaData defining sample groups [ str, "Group" ]
#' @param nodeColour            Name of column in metaData defining sample colours [ str, "Colour" ]
#' @param d3.nodeSize           Name of column in metaData defining node sizes for networkD3 [ str, "Size" ]
#' @param d3.height             Height of widget networkD3 [ numeric, NULL ]
#' @param d3.width              Width of widget networkD3 [ numeric, NULL ]
#' @param d3.colourScale        Colour scale to use for groups in networkD3 [ str, NULL ]
#' @param d3.fontSize           Font size for labels in networkD3 [ int, 7 ]
#' @param d3.fontFamily         Font family for labels in networkD3 [ str, "times" ]
#' @param d3.linkDistance       Edge distance for force-directed layout in networkD3 [ int, 50 ]
#' @param d3.linkWidth          JS function to determine edge width [ str, "function(d) { return Math.sqrt(d.value); }" ]
#' @param d3.radiusCalculation  JS expression to determine node radius [ str, "Math.sqrt(d.nodesize)+6" ]           
#' @param d3.linkColour         Colour od edges for networkD3 [ str, "#666" ]
#' @param d3.charge             Charge parameter for force-directed layout networkD3 [ int, -120 ]
#' @param d3.opacity            Node opacity for networkD3 [ numeric, 0.8 ]
#' @param d3.zoom               Zoom for networkD3 [ bool, TRUE ]         
#' @param d3.legend             Legend for networkD3, using Groups [ bool, FALSE ]
#' @param d3.bounded            Bounds for networkD3 [ bool, FALSE ]
#' @param d3.opacityNoHover     Opacity change when hovering in networkD3 [ numeric, 0 ]
#' @param d3.clickAction        JS function for clicking a node in networkD3 [ str, NULL ]
#' @param d3.linkX              Multiplier for link distance, use instead of specifiying JS function in d3.linkWidth [ numeric, 20 ]
#' 
#' @return List of options for NetView.
#' 
#' @usage netviewOptions(...)
#' 
#' @details For examples and tutorials, please see our GitHub Repository: \url{https://github.com/esteinig/netview}
#' \itemize{
#'    \item{Allowed community-detection algorithm names are "Walktrap", "Infomap", "Fast-Greedy", "Edge Betweenness", "Label Propagation", "Louvain" and "Leading Eigenvector"}
#'    \item{Allowed mutual nearest neighbour search algorithms, as implemented in nng from package cccd are "cover_tree", "kd_tree", "CR", "brute"}
#' } 
#' 
#'          
#'  
#' @export


netviewOptions <- function(mknnWeights=TRUE, mknnAlgorithm='cover_tree', communityAlgorithms = c("Walktrap", "Infomap", "Fast-Greedy"),
                           selectionTitle = "Communities in mkNNGs", selectionPlot = c(5, 20, 1),
                           nodeID = 'ID', nodeGroup = 'Group', nodeColour = 'Colour', d3.nodeSize = 'Size',
                           d3.height = NULL, d3.width = NULL, d3.colourScale = NULL,
                           d3.fontSize = 7, d3.fontFamily = "times", d3.linkDistance = 50,
                           d3.linkWidth = "function(d) { return Math.sqrt(d.value); }",
                           d3.radiusCalculation = "Math.sqrt(d.nodesize)+6", d3.charge = -120,
                           d3.linkColour = "#666", d3.opacity = 0.8, d3.zoom = TRUE, d3.legend = FALSE,
                           d3.bounded = FALSE, d3.opacityNoHover = 0, d3.clickAction = NULL, d3.linkX = 20) {
  
  if(is.null(d3.colourScale)){
    
    nodeColour <- nodeColour
    
  } else {
    
    # e.g. "d3.scale.category20()"
    nodeColour <- JS(d3.colourScale)
    
  }
  
  opts <- list('mknn.weights' = mknnWeights,
               'mknn.algorithm' = mknnAlgorithm,
               'community.algorithms' = communityAlgorithms,
               'selection.title' = selectionTitle,
               'selection.plot' = selectionPlot,
               
               'nodeID' = nodeID,
               'nodeColour' = nodeColour,
               'nodeGroup' = nodeGroup,
               
               'd3.nodeSize' = d3.nodeSize,
               'd3.height' = d3.height,
               'd3.width' = d3.width,
               'd3.colourScale' = d3.colourScale,
               'd3.fontSize' = d3.fontSize,
               'd3.fontFamily' = d3.fontFamily,
               'd3.linkDistance' = d3.linkDistance,
               'd3.linkWidth' = JS(d3.linkWidth),
               'd3.radiusCalculation' = JS(d3.radiusCalculation),
               'd3.charge' = d3.charge,
               'd3.linkColour' = d3.linkColour,
               'd3.opacity' = d3.opacity,
               'd3.zoom' = d3.zoom,
               'd3.legend' = d3.legend,
               'd3.bounded' = d3.bounded,
               'd3.opacityNoHover' = d3.opacityNoHover,
               'd3.clickAction' = d3.clickAction,
               'd3.linkX' = d3.linkX)
  
  return(opts)
  
}