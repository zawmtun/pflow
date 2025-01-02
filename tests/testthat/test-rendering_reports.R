# tests/testthat/test-rendering_reports.R

test_that("body_add_blank_lines adds correct number of blank lines", {
  doc <- officer::read_docx()

  # Test adding single blank line
  result1 <- body_add_blank_lines(doc, 1)
  expect_equal(result1$officer_cursor$which, 1)

  # Test adding multiple blank lines
  result2 <- body_add_blank_lines(doc, 3)
  expect_equal(result2$officer_cursor$which, 3)

  # Test with zero lines
  result3 <- body_add_blank_lines(doc, 0)
  expect_equal(result3$officer_cursor$which, 0)
})

test_that("create_title_page creates document with required fields", {
  # Basic test with mandatory fields
  doc <- create_title_page(
    project_name = "Test Project",
    title = "Test Title",
    author = "Test Author"
  )
  expect_s3_class(doc, "rdocx")

  # Test with all optional fields
  doc_full <- create_title_page(
    project_name = "Test Project",
    title = "Test Title",
    author = "Test Author",
    designation = "Senior Analyst",
    department = "Research Department",
    report_date = "01-01-2024"
  )
  expect_s3_class(doc_full, "rdocx")

  # Test with some optional fields
  doc_partial <- create_title_page(
    project_name = "Test Project",
    title = "Test Title",
    author = "Test Author",
    designation = "Senior Analyst"
  )
  expect_s3_class(doc_partial, "rdocx")
})

test_that("render_report validates inputs correctly", {
  # Create temporary test files
  temp_dir <- tempdir()
  test_rmd <- file.path(temp_dir, "test_report.Rmd")
  on.exit(unlink(c(test_rmd, sub("\\.Rmd$", ".docx", test_rmd))))

  writeLines(
    c("---",
      "title: 'Test Report'",
      "---",
      "",
      "# Test Content",
      "This is a test report."),
    test_rmd
  )

  # Test with add_title_page = TRUE (should error)
  expect_error(
    render_report(test_rmd, add_title_page = TRUE),
    "To add a title page, please provide a list"
  )

  # Test with invalid list (missing required fields)
  expect_error(
    render_report(test_rmd,
                  add_title_page = list(project_name = "Test")),
    "must contain at least 3 elements"
  )

  # Test with invalid input type
  expect_error(
    render_report(test_rmd, add_title_page = "TRUE"),
    "`add_title_page` must be either a `logical` or a `list`"
  )
})

test_that("render_report produces expected output", {
  skip_on_cran()  # Skip on CRAN as it creates files

  # Create temporary test files
  temp_dir <- tempdir()
  test_rmd <- file.path(temp_dir, "test_report.Rmd")
  on.exit(unlink(c(test_rmd, sub("\\.Rmd$", ".docx", test_rmd))))

  writeLines(
    c("---",
      "title: 'Test Report'",
      "---",
      "",
      "# Test Content",
      "This is a test report."),
    test_rmd
  )

  # Test basic rendering
  output_file <- render_report(test_rmd, add_title_page = FALSE)
  expect_true(file.exists(output_file))
  expect_equal(
    basename(output_file),
    paste0(tools::file_path_sans_ext(basename(test_rmd)), ".docx")
  )

  # Test rendering with title page
  title_page_info <- list(
    project_name = "Test Project",
    title = "Test Title",
    author = "Test Author"
  )

  withr::with_dir(temp_dir, {
    output_file <- render_report(test_rmd, add_title_page = title_page_info)
    expect_true(file.exists(output_file))
  })
})
