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

  usethis::use_template("blank.R", save_as = "code/_main.R", package = "pflow")
  usethis::use_template("packages.R", package = "pflow")
}


#' Generate a R code file path
#'
#' @param file_name of the R code file.
#'
#' @return R code file text in console.
#'
code_target <- function(file_name) {
  glue::glue("Add this code to your _main.R:\n",
             "\n",
             "source(",
             "\"{file.path('code', paste(file_name, 'R', sep = '.'))}\"",
             ")")
}


#' Create a code file and generate a R code file path
#'
#' @param file_name of the R code file.
#'
#' @return the path of the file created.
#' @export
#'
use_code <- function(file_name) {

  target_file <- paste0(file_name, ".R")
  code_dir <- getOption('pflow.code_dir') %||% "code"
  file_path <- file.path(code_dir, target_file)

  if (file.exists(file_path)) {
    message(file_path, " already exists and was not overwritten.")
    message(code_target(file_name))
    return(invisible(file_path))
  }

  usethis::use_template("blank.R",
                        save_as = file_path,
                        package = "pflow")

  message(code_target(file_name))

}


#' Generate a QMD file path
#'
#' @param file_name of the QMD file
#'
#' @return a QMD file path in console
#'
qmd_target <- function(file_name) {

  report_dir <- getOption('pflow.report_dir') %||% "docs"

  glue::glue("Add this code to your _main.R:\n",
             "\n",
             "quarto_render(",
             "\"{file.path(report_dir, paste(file_name, 'qmd', sep = '.'))}\"",
             ", output_format = \"docx\")")
}


#' Create a QMD file and generate a file path
#'
#' @description
#' Create a QMD file pre-configured to generate a docx file. It also creates a custom Word template file if it does not already exist.
#'
#' @param file_name of the QMD file
#' @param pflow_path path of \{pflow\} package. If NULL, the first of .libPaths() is used.
#'
#' @return the path of the file created (invisibly).
#' @export
#'
use_docx <- function(file_name, pflow_path = NULL) {

  target_file <- paste0(file_name, ".qmd")
  report_dir <- getOption('pflow.report_dir') %||% "docs"
  file_path <- file.path(report_dir, target_file)

  if (file.exists(file_path)) {
    message(file_path, " already exists and was not overwritten.")
    message(qmd_target(file_name))
    return(invisible(file_path))
  }

  if (!dir.exists(report_dir)) usethis::use_directory(report_dir)

  usethis::use_template("blank.qmd",
                        save_as = file_path,
                        package = "pflow")

  message(qmd_target(file_name))

  refdoc_path <- file.path(report_dir, "pflow_reference.docx")
  lib_path <- pflow_path %||% .libPaths()[1]

  if (!file.exists(refdoc_path)) {
    doc <- file.path(lib_path, "pflow/templates/pflow_reference.docx")
    file.copy(doc, refdoc_path)
    message(glue::glue("\nWord reference document added: {refdoc_path}"))
  }

  if (file.exists("./packages.R") && !contains_quarto("./packages.R")) {
    packages <- readr::read_lines("./packages.R")
    packages <- c(packages, "library(quarto)")
    readr::write_lines(packages, "./packages.R")
    message("Writing 'library(quarto)' to './packages.R'")
  }

  invisible(file_path)

}
