#' Source packages.R
#'
#' @export
#'
pflow_load_packages <- function() {
  message("\nLoading `packages.R`.")
  if (file.exists("packages.R")) {
    suppressPackageStartupMessages(source("packages.R"))
  } else {
    message("No `packages.R` found.")
  }
}
