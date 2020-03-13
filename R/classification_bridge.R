#' Datasets to bridge (translate) common sector-classification codes
#'
#' These datasets help to bridge (translate) common sector classification codes
#' from the wild to codes we use in 2dii such as 'power', 'oil and gas', 'coal',
#' 'automotive', 'aviation', 'concrete', 'steel', and 'shipping'.
#'
#' @seealso [data_dictionary].
#'
#' @family datasets for bridging sector classification codes
#'
#' @return A [data.frame] (subclass 'tbl').
#'
#' @name classification_bridge
#'
#' @examples
#' head(isic_classification)
#'
#' head(nace_classification)
#'
#' head(naics_classification)
NULL

#' @rdname classification_bridge
"isic_classification"

#' @rdname classification_bridge
"nace_classification"

#' @rdname classification_bridge
"naics_classification"
