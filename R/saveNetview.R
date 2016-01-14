saveNetview <- function(graphs=list(), networkD3=FALSE, project='project', options=NULL) {
  
  wd <- getwd()
  outdir <- file.path(wd, project)
  if(dir.exists(outdir)){
    unlink(outdir, recursive = T)
  }
  dir.create(outdir)
  setwd(outdir)
  
  if (networkD3==TRUE) {
    
    for (i in seq_along(graphs)) {
      
      filename <- paste0(project, '_k', names(graphs)[i], '.html')
      saveWidget(graphs[[i]], filename, selfcontained=T)
      
    }
    
  } else {
    
    for (i in seq_along(graphs)) {
      
      filename <- paste0(project, '_k', names(graphs)[i], '.gml')
      write.graph(graphs[[i]], filename, format='gml')

    }
    
  }
  
  setwd(wd)
  
}  