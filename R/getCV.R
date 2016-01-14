getCV <- function(out){
  
  cv_line <- grep('CV error*', out)
  print(cv_line)
  
  cv_str <- out[cv_line]
  print(cv_str)
  
  cv <- as.numeric(regmatches(cv_str,regexpr("[[:digit:]]+\\.[[:digit:]]+",cv_str)))
  
  return(cv)
  
}