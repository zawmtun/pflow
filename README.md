# Project Workflow


<!-- badges: start -->

<!-- badges: end -->

\{pflow\} R package is a collection of functions for setting up a project and for reducing friction of a data analysis process. Some of the functions in this package are direct adaption from [Miles McBain's {tflow} package](https://github.com/MilesMcBain/tflow/tree/master).

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

`pflow::use_code("plotting")` creates a R code file:

```
✔ Writing 'code/plotting.R'
Add this code to your _main.R:

source("code/plotting.R")
```

`pflow::use_docx("analysis")`:

```
✔ Writing 'docs/analysis.qmd'
Add this code to your _main.R:

quarto_render("docs/analysis.qmd", output_format = "docx")

Word reference document added: docs/pflow_reference.docx
```

## Defaults

\{tidyverse\} library call is included in `packages.R` by default. Some dplyr function names are often conflicted with other packages. These conflicts are pre-emptively avoided by using \{conflicted\} package.

```
library(tidyverse)
library(conflicted)
conflict_prefer("select", "dplyr")
conflict_prefer("filter", "dplyr")
```
