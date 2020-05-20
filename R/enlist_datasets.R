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
