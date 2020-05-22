#' Datasets to bridge (translate) common sector-classification codes
#'
#' @description
#' These datasets serve as a translation key between common sector-classification
#' systems and sectors relevant to the 'PACTA' tool
#' (<https://2degrees-investing.org/resource/pacta/>).
#' @template info_classification-datasets
#'
#' @family datasets for bridging sector classification codes
#' @seealso [data_dictionary].
#'
#' @name classification_bridge
#' @aliases isic_classification nace_classification naics_classification
#'
#' @examples
#' head(isic_classification)
#'
#' head(nace_classification)
#'
#' head(naics_classification)
NULL

#' @rdname classification_bridge
#'
"isic_classification"

#' @rdname classification_bridge
#'
"nace_classification"

#' @rdname classification_bridge
#'
"naics_classification"
