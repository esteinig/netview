readArchive <- function(data, archive) {
  
  out <- file.path(getwd(), "admixture_plot_tmp")
  
  id <- data$ID
  pop <- data$Group
  
  dir.create(out)
  
  files <- unzip(archive, list = F, exdir = out) 
  
  q_files <- list.files(path=file.path(getwd(), "admixture_plot_tmp"), pattern = "\\.Q$")
  
  K_values <- as.vector(sapply(q_files, function(f) { return(as.numeric(gsub("[^0-9]","", f) ))}))
  
  names(K_values) <- as.vector(sapply(q_files, function(f) { return(file.path(out, f)) }))
  
  files <- names(K_values)[order(K_values)]
  
  q_data <- lapply(files, function(file_name){
    q_matrix <- as.data.frame(read.table(file_name, header=F, sep=' '))
    pops <- seq(1, dim(q_matrix)[2], 1)
    names <- sapply(pops, function(x){ paste0('Pop', x) })
    q_matrix <- cbind(Population = id, q_matrix)
    q_matrix <- cbind(ID = pop, q_matrix)
    names(q_matrix) <- append(c('Population', 'ID'), names)
    return(q_matrix)
  })
  
  K_values <- K_values[order(unlist(K_values))]
  
  names(q_data) <- K_values
  unlink("admixture_plot_tmp", force = T, recursive = T)
  
  return(q_data)
}
