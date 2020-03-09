#' A dataset that defiles the columns of r2dii datasets
#'
#' @section Extending the data dictionary:
#' To extend the output of `data_dictionary()` so that it includes
#' the `definition` and `typeof` each `column` of a new `dataset`,
#' you should fill the Google Sheet at <http://bit.ly/data_dictionary_template>,
#' then create a new dataset issue at <http://bit.ly/new-dataset-issue>.
#'
#' @family demo datasets
#' @return A [dplyr::tibble].
#'
#' @export
#' @examples
#' data_dictionary()
data_dictionary <- function() {
  parent <- system.file("extdata", package = "r2dii.data")
  paths <- list.files(parent, full.names = TRUE)
  out <- purrr::map_dfr(paths, readr::read_csv, col_types = "cccc")
  dplyr::arrange(out, .data$dataset, .data$column)
}
