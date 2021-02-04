#' Use a new sector classification in r2dii.data
#'
#' These functions help you add a new sector classification bridge.
#'
#' @param dataset String. Name of the new classification dataset you want to
#'   add, with the format `[prefix]_classification`, e.g. `psic_classification`.
#' @param data A data frame.
#' @param contributor String. Name of a contributor to thank in NEWS.md, e.g.
#'   "\@daisy-pacheco".
#' @param issue String. Number of related issue or PR, e.g. #199.
#' @param overwrite Logical. Allow overwriting data?
#'
#' @return Most functions are interactive, and called for their side effects.
#' The return value is usually `invisible(dataset)`.
#'
#' @examples
#' # This is an internal function aimed at developers
#' load_all()
#'
#' # The source code does not ship with the package to avoid dependencies
#' source_use_bridge()
#'
#' # This is usually a contributed spreadsheet
#' data <- r2dii.data::psic_classification
#'
#' # The dataset name must have the format [prefix]_classificaton
#' dataset <- name_dataset("fake")
#' dataset
#'
#' contributor <- "@somebody"
#' issue <- "#123"
#'
#' use_bridge(dataset, data, contributor, issue, overwrite = TRUE)
#' @noRd
source_use_bridge <- function() {
  path <- file.path("data-raw", "use_bridge.R")
  source(path)
}

#' Source all .R files under data-raw/
#'
#' Usually we work on one dataset only, and don't know if our change impacted
#' other datasets. This function helps "refresh" all datasets at once. It may
#' be used interactively while developing the package, or in CI to regularly
#' check we can reproduce all datasets we export, and that the result is
#' consistent with our regression tests.
#'
#' @return `invisible()`, as it's called for its side effect.
#' @keywords internal
#'
#' @examples
#' source_data_raw()
#' @noRd
source_data_raw <- function(path = "data-raw") {
  lapply(r_files_in(path), source)

  invisible(path)
}

r_files_in <- function(path) {
  # pattern = "[.]R$" is simpler but platform-inconsistent, e.g. "a//b", "a/b".
  path_ext <- list.files(path, pattern = NULL, full.names = TRUE)
  grep("[.]R$", path_ext, value = TRUE)
}

#' Create a list of all or some datasets exported by a package
#'
#' @param package A character string of length-1 giving the name of a package.
#' @param pattern A pattern to pass to `grep()`. Defaults to match everything.
#'
#' @return A list.
#'
#' @examples
#' # Must be attached
#' library(r2dii.data)
#'
#' names(enlist_datasets("r2dii.data"))
#' names(enlist_datasets("r2dii.data", pattern = "^ald"))
#' @noRd
enlist_datasets <- function(package, pattern = "") {
  data <- grep(pattern, exported_data(package), value = TRUE)
  stats::setNames(mget(data, inherits = TRUE), data)
}

#' Create a character vector of all datasets exported by a package
#'
#' @param package A character string of length-1 giving the name of a package.
#'
#' @return A character vector.
#'
#' @examples
#' # Must be attached
#' library(r2dii.data)
#' exported_data("r2dii.data")
#' @noRd
exported_data <- function(package) {
  utils::data(package = package)$results[, "Item"]
}

#' Define columns of a dataset in [data_dictionary]
#'
#' @param dataset A character string giving the name of a dataset.
#'
#' @return A character vector of subclass "glue".
#'
#' @examples
#' define("region_isos")
#' @noRd
define <- function(dataset) {
  d <- r2dii.data::data_dictionary
  d <- d[d$dataset == dataset, , drop = FALSE]

  out <- sprintf("* `%s` (%s): %s.", d$column, d$typeof, d$definition)
  # HACK: We don't use glue but it's class helps get the correct format
  class(out) <- c("glue", class(out))

  out
}
