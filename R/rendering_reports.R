#' Add blank lines in the MS Word document
#'
#' @param doc 'Word' document object
#' @param n Integer. Number of blank lines to add.
#'
#' @returns Updated 'Word' document object
body_add_blank_lines <- function(doc, n = 1) {
  for (i in seq_len(n)) {
    doc <- officer::body_add_par(doc, "", style = "Normal")
  }
  doc
}


#' Create a title page of a report as a 'Word' object
#'
#' @param project_name Project name
#' @param title Title of the report
#' @param author Author's name. Optionally, include your post-nominal title (MSc, PhD, etc).
#' @param designation Author's designation
#' @param department Author's department within SCRI
#' @param report_date Reporting date in the format "dd-mm-yyyy". If not provided, the system's date is used.
#'
#' @details
#' Here is the output of example 1:\cr
#' \if{html}{
#'   \figure{titlepage_example1.png}{options: style="width:60\%" alt="Screenshot of function output"}
#' }
#' \if{latex}{
#'   \figure{titlepage_example1.png}{options: width=10cm}
#' }
#'
#' Here is the output of example 2:\cr
#' \if{html}{
#'   \figure{titlepage_example2.png}{options: style="width:60\%" alt="Screenshot of function output"}
#' }
#' \if{latex}{
#'   \figure{titlepage_example2.png}{options: width=10cm}
#' }
#'
#' @returns A 'Word' object from \{officer\} package
#' @export
#'
#' @examples
#' \dontrun{
#' # Example 1: A title page requires three parameters at a minimum.
#' create_title_page(
#'   project_name = "Test Project",
#'   title = "Test Title",
#'   author = "Test Author"
#' ) |>
#' print("titlepage.docx")
#'
#' # Example 2: Including optional parameters
#' create_title_page(
#'   project_name = "Test Project",
#'   title = "Test Title",
#'   author = "Test Author",
#'   designation = "Senior Analyst",
#'   department = "Research Department",
#'   report_date = "01-01-2024"
#' )
#' ) |>
#' print("titlepage.docx")
#' }
#'
create_title_page <- function(project_name, title, author,
                              designation = NULL,
                              department = NULL,
                              report_date = NULL) {

  # Define formatting properties
  par_properties <- officer::fp_par(text.align = "center", padding = 5)
  title_properties <- officer::fp_text_lite(font.size = 20, bold = TRUE)
  author_properties <- officer::fp_text_lite(font.size = 16)
  desig_properties <- officer::fp_text_lite(font.size = 14)

  # Construct formatted text elements
  project_name_par <- officer::ftext(project_name, prop = title_properties) |>
    officer::fpar(fp_p = par_properties)

  title_par <- officer::ftext(title, prop = title_properties) |>
    officer::fpar(fp_p = par_properties)

  author_par <- officer::ftext(author, prop = author_properties) |>
    officer::fpar(fp_p = par_properties)

  # Get the package-correct path to the image
  img_path <- system.file("images", "scri_logo.png", package = "pflow")
  if (img_path == "") {
    stop("Could not find the logo file. Please ensure 'scri_logo.png' is installed in package's 'images' directory")
  }

  # Initialise document and add project_name, title, and author
  doc <- officer::read_docx() |>
    body_add_blank_lines(n = 2) |>
    officer::body_add_img(src = img_path,
                 style = "centered",
                 height = 2.36 * 1.3 * 0.393701,
                 width = 3.61 * 1.3 * 0.393701,
                 pos = "after") |>
    body_add_blank_lines(n = 7) |>
    officer::body_add_fpar(project_name_par) |>
    officer::body_add_fpar(title_par) |>
    body_add_blank_lines(n = 7) |>
    officer::body_add_fpar(author_par)

  # Include designation if available
  if (!is.null(designation)) {
    doc <- doc |>
      officer::body_add_fpar(
        officer::fpar(officer::ftext(designation, prop = desig_properties), fp_p = par_properties)
      )
  }

  if (!is.null(department)) {
    doc <- doc |>
      officer::body_add_fpar(
        officer::fpar(officer::ftext(department, prop = desig_properties), fp_p = par_properties)
      )
  }

  if (is.null(designation) && is.null(department)) {
    doc <- doc |> body_add_blank_lines(n = 2)
  }

  # Include report creation date
  report_date <- ifelse(
    is.null(report_date),
    Sys.Date(),
    as.Date(report_date, "%d-%m-%Y")
  ) |>
    as.Date()

  date_par <- officer::fpar(
    officer::ftext(format(report_date, "%e %B %Y")),
    fp_p = par_properties
  )

  doc <- doc |>
    body_add_blank_lines(n = 10) |>
    officer::body_add_fpar(date_par)

  doc
}


#' Render the input report RMarkdown file to MS Word document
#'
#' @param rmd_file File path of a RMarkdown file
#' @param add_title_page If FALSE (default), no title page added. To add one, specify details of a title as a list.
#' @details
#' In the list for the title page details, At least `project_name`, `title`, and `author` must be specificed. `designation` and `department` are optional. `report_date` must be in the format "dd-mm-yyyy"; if not provided, system's date is used.
#'
#' @returns File path of the resulting MS Word document.
#' @export
#'
#' @examples
#' \dontrun{
#' render_report(
#'   rmd_file = "example.Rmd",
#'   add_title_page = list(project_name = "Test Project",
#'                         title = "Test Title",
#'                         author = "Test Author",
#'                         designation = "Senior Analyst",
#'                         department = "Research Department",
#'                         report_date = "01-01-2024")
#' )
#' }

render_report <- function(rmd_file, add_title_page = FALSE) {
  stopifnot(
    "`add_title_page` must be either a `logical` or a `list`" =
      class(add_title_page) %in% c("logical", "list")
  )

  if (is.logical(add_title_page) && add_title_page) {
    stop("To add a title page, please provide a list containing at least `project_name`, `title`, and `author`, instead of `TRUE`")
  }

  if (is.list(add_title_page)) {
    stopifnot(
      "`add_title_page` must contain at least 3 elements: `project_name`, `title`, and `author`" =
        all(c("project_name", "title", "author") %in% names(add_title_page))
    )
  }

  # Define output file path
  output_file <- file.path(
    dirname(rmd_file),
    paste0(tools::file_path_sans_ext(basename(rmd_file)), ".docx")
  )

  # Render the RMarkdown file
  rmarkdown::render(input = rmd_file,
                    output_format = "word_document",
                    output_file = output_file)

  # Add a title page if specified
  if (is.list(add_title_page)) {
    # Create and append the title page
    title_page <- create_title_page(
      project_name = add_title_page$project_name,
      title = add_title_page$title,
      author = add_title_page$author,
      designation = add_title_page$designation,
      department = add_title_page$department,
      report_date = add_title_page$report_date
    )

    doc <- title_page |>
      officer::body_add_break() |>
      officer::body_add_docx(src = output_file)

    print(doc, output_file)
  }

  output_file
}
