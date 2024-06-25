# Project Workflow


<!-- badges: start -->

<!-- badges: end -->

\{pflow\} R package is a collection of functions for setting up a project and for reducing friction of a data analysis process. Some of the functions in this package are adapted from [Miles McBain's {tflow} package](https://github.com/MilesMcBain/tflow/tree/master).

## Installation

``` r
# install.packages("devtools")
devtools::install_github("zawmtun/pflow")
```

## Usage

### Setting up a project directory structure

`pflow::use_pflow()` creates an opinionated directory structure:

```
./
|_ code/
|_ data_derived/
|_ data_external/
|_ packages.R
```

`pflow::use_code("plotting")` creates a template R code file:

```
✔ Writing 'code/plotting.R'
Add this code to your _main.R:

source("code/plotting.R")
```

`pflow::use_docx("my_report1")` creates a template QMD file for DOCX output:

```
✔ Writing 'docs/my_report1.qmd'
Add this code to your _main.R:

quarto_render("docs/my_report1.qmd", output_format = "docx")

Word reference document added: docs/pflow_reference.docx
```

`pflow::use_html("my_report2")` creates a template QMD file for HTML output:

```
✔ Writing 'docs/my_report2.qmd'
Add this code to your _main.R:

quarto_render("docs/my_report2.qmd", output_format = "html")
```
