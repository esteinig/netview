#'@export

installNetView <- function(){
  
  packages <- c('igraph', 'cccd', 'htmlwidgets', 'networkD3', 'ape',
                'gplots', 'ggplot2', 'reshape2', 'RColorBrewer')
  
  vcontrol <- function() {
    
    major <- as.integer(version$major)
    minor <- as.double(version$minor)
    
    if (major < 3){
      message('NetView R requires R version 3.')
      exit(1)
    } else {
      message('Passed major version of R.')
    }
    
    if (minor < 2.1) {
      message('NetView R requires R version > 3.2.1.')
      exit(1)
    } else {
      message('Passed minor version of R.')
    }
    
    message('Version control complete, ready to check packages...')
    message('----------------------------------------------------')
    
  }
  
  ipak <- function(pkg){
    
    # https://gist.github.com/stevenworthington/3178163
    
    message('Checking packages...')
    new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
    message(paste('There are', length(new.pkg), 'new packages:'))
    sapply(new.pkg, function(x) {message(x)})
    if (length(new.pkg)) {
      message('--------------------------')
      install.packages(new.pkg, dependencies = TRUE) 
    }
  }
  
  vcontrol()
  ipak(packages)
  
  
}
