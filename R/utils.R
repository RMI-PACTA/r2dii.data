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
source_data_raw <- function() {
  lapply(r_files_in("data-raw"), source)
  invisible()
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
