#' Project workflow template
#'
#' @description
#' This initialises the project using a template within a RStudio project.
#'
#' @export
#'
use_pflow <- function() {
  folders <- c("code", "data_derived", "data_external")

  for (f in folders) {
    usethis::use_directory(f)
  }

  usethis::use_template("packages.R", package = "pflow")
}
