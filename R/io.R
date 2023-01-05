#' Save a maxnet model as a serialize R data object
#' 
#' This provides a pipeable workflow.
#' 
#' @export
#' @param x maxnet model
#' @param filename character, the name of the file to save (use .rds extension recommended)
#' @param ... other arguments for \code{\link[base]{saveRDS}}
#' @return the input x
write_maxnet <- function(x, filename, ...){
  saveRDS(x, file = filename[1], ...) 
}

#' Read a maxnet model file
#' 
#' @export
#' @param filename char, filename of the file to read
#' @param ... other arguments for \code{\link[base]{readRDS}}
#' @return maxnet object
read_maxnet <- function(filename, ...){
  readRDS(filename, ...)
}
