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
  out <- dplyr::bind_rows(
    get_inst_extdata("data_dictionary.csv"),
    get_inst_extdata("loanbook.csv"),
    get_inst_extdata("ald.csv"),
    get_inst_extdata("overwrite.csv"),
    get_inst_extdata("scenario.csv"),
    get_inst_extdata("nace_classification.csv"),
    get_inst_extdata("isic_classification.csv"),
    get_inst_extdata("iso_codes.csv"),
    get_inst_extdata("region_isos.csv")
  )

  dplyr::arrange(out, .data$dataset, .data$column)
}

path_inst_extdata <- function(regexp = NULL) {
  fs::dir_ls(
    system.file("extdata", package = "r2dii.dataraw"),
    regexp = regexp
  )
}

get_inst_extdata <- function(regexp = NULL) {
  suppressMessages(
    readr::read_csv(path_inst_extdata(regexp))
  )
}
