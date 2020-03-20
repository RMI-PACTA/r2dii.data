#' Datasets to bridge (translate) common sector-classification codes
#'
#' @template info_general
#' @template info_classification-datasets
#' @description This dataset serves as a translation key between common
#'   sector-classification systems and 2dii's sectors.
#'
#' @seealso [data_dictionary].
#'
#' @family datasets for bridging sector classification codes
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
#' @format
#' `classification_bridge` is a [data.frame] with columns:
#' * `borderline` (logical): Flag indicating if 2dii sector and classification
#' code are a borderline match.
#' * `code` (character): Original ISIC code.
#' * `code_level` (double): Level of granularity of ISIC code.
#' * `sector` (character): Associated 2dii sector.
#'
"isic_classification"

#' @rdname classification_bridge
#' @format
#' `nace_classification` is a [data.frame] with columns:
#' * `borderline` (logical): Flag indicating if 2dii sector and classification
#' code are a borderline match.
#' * `code` (double): Formatted NACE code removing periods.
#' * `code_level` (double): Level of granularity of NACE code.
#' * `original_code` (double): Original NACE code.
#' * `sector` (character): Associated 2dii sector.
#'
"nace_classification"

#' @rdname classification_bridge
#' @format
#' `naics_classification` is a [data.frame] with columns:
#' * `borderline` (logical): Flag indicating if 2dii sector and classification
#' code are a borderline match.
#' * `code` (double): Formatted NAICS code.
#' * `code_level` (double): Level of granularity of NAICS code.
#' * `original_code` (double): Original NAICS code.
#' * `sector` (character): Associated 2dii sector.
#'
"naics_classification"
