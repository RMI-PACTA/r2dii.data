#' Datasets to bridge (translate) common sector-classification codes
#'
#' These datasets help to bridge (translate) common sector classification codes
#' from the wild to codes we use in 2dii such as 'power', 'oil and gas', 'coal',
#' 'automotive', 'aviation', 'concrete', 'steel', and 'shipping'.
#'
#' @seealso [data_dictionary()].
#'
#' @family datasets for bridging sector classification codes
#'
#' @return A [dplyr::tibble].
#'
#' @name classification_bridge
#'
#' @examples
#' isic_classification
#' nace_classification
#' naics_classification
NULL

#' @rdname classification_bridge
"isic_classification"

#' @rdname classification_bridge
"nace_classification"

#' @rdname classification_bridge
"naics_classification"
