#' Check if quarto library call exists in packages.R
#'
#' @param filepath of packages.R
#'
#' @return a boolean
#'
contains_quarto <- function(filepath) {

  libs_file_lines <- readr::read_lines(filepath)

  any(grepl("^library\\(quarto\\)", libs_file_lines))

}
