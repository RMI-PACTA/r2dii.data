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
  d <- data_dictionary
  d <- d[d$dataset == dataset, , drop = FALSE]
  d$dataset <- NULL

  out <- sprintf("* `%s` (%s): %s.", d$column, d$typeof, d$definition)
  class(out) <- c("glue", class(out))
  out
}
