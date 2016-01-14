#' Admixture
#' 
#' Convenience function for running Admixture.
#' 
#' @param file              Zipped input data for Admixture containing PLINK binary files, ordered same as metaData for NetView
#' @param project           Name of temporary output directory and final zipped output file for plotAdmixture() [ str, "admixture_graph" ]
#' @param K                 Range of K for Admixture [ int vector, 1:10]
#' @param processors        Number of processors for analysis [ int, 1 ]
#' @param crossValidation   Number of cross-validation error iterations [ int, 20 ]
#' 
#' @return Graph object with data for plotting admixture proportions or bar plot from Structure Plot.
#' 
#' @usage runAdmixture("oyster.zip", oysterData, K=1:10, ...)
#' 
#' @details For examples and tutorials, please see our GitHub Repository: \url{https://github.com/esteinig/netview}
#' \itemize{
#'      \item{Input files should be generated in PLINK, using the "make-bed" option (.bed, .bim, .fam)}
#'      \item{Admixture executable needs to be in $PATH}
#'      \item{If you encounter an error during analysis, please delete the temporary directory and reset your current working directory before running the analysis again}
#'      }
#'      
#' @export

runAdmixture <- function(file, project='admixture_graph', K=1:10, processors=1, crossValidation=20) {
  
  wd <- getwd()
  
  adm_path <- file
  
  target_dir <- file.path(wd, project)
  
  files <- unzip(adm_path, list = F, exdir = target_dir) 
  
  file_paths <- unzip(adm_path, list = T, exdir = target_dir)
  
  setwd(target_dir)
  
  cross_error <- c()
  
  adm_cv <- crossValidation
  adm_proc <- processors
  
  for (k in K) {
    
    print(paste0('admixture --cv=', adm_cv, ' ', '-j', adm_proc, ' ', file_paths$Name[1], ' ', k))
    
    out <- system(paste0('admixture --cv=', adm_cv, ' ', '-j', adm_proc, ' ', file_paths$Name[1], ' ', k), intern = T)
    
    print(out)
    
    cv <- getCV(out)
    
    cross_error <- append(cross_error, cv)
  } 
  
  outfiles <- list.files(target_dir, full.names = F)
  
  zip(file.path(wd, paste0(project, '.zip')), files=outfiles)
  
  setwd(wd)
  
  unlink(target_dir, force = T, recursive = T)
  
  names(cross_error) = K
  
  results = list("outFile" = file.path(wd, paste0(project, '.zip')), "crossError" = cross_error)
  
  return(results)
  
}