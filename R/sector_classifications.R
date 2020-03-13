#' A view of available sector classification datasets
#'
#' @seealso [data_dictionary()].
#' @family datasets for bridging sector classification codes
#'
#' @return A [tibble::tibble()]. The column `code_system` names one of the
#'   classification systems that 2dii uses. All other columns are defined at
#'   [data_dictionary()].
#'
#' @examples
#' sector_classifications
#'
#' dd <- data_dictionary()
#' dd[dd$dataset == "sector_classifications", ]
"sector_classifications"

