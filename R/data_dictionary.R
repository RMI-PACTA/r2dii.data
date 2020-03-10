#' A dataset that defiles the columns of r2dii datasets
#'
#' @section Extending the data dictionary:
#' To extend the output of `data_dictionary()` so that it includes
#' the `definition` and `typeof` each `column` of a new `dataset`,
#' you should fill the Google Sheet at <http://bit.ly/data_dictionary_template>,
#' then create a new dataset issue at <http://bit.ly/new-dataset-issue>.
#'
#' @family demo datasets
#' @return A [tibble::tibble].
#'
#' @export
#' @examples
#' data_dictionary()
data_dictionary <- function() {
  parent <- system.file("extdata", package = "r2dii.data")
  paths <- list.files(parent, full.names = TRUE)

  out <- purrr::map(
    paths,
    ~ tibble::as_tibble(utils::read.csv(
      .x,
      colClasses = "character",
      na.strings = c("", "NA"),
      stringsAsFactors = FALSE
    ))
  ) %>% purrr::reduce(rbind)

  out[order(out$dataset, out$column), , drop = FALSE]
}
