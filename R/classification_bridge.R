#' Dataset to bridge (translate) common sector-classification codes
#'
#' @description
#' These dataset serve as a translation key between common sector-classification
#' systems and sectors relevant to the 'PACTA' tool
#' (<https://2degrees-investing.org/resource/pacta/>).
#'
#'
#' @family datasets for bridging sector classification codes
#' @seealso [data_dictionary].
#'
#' @section Definitions:
#' `r define("isic_classification")`
#'
#' @template info_classification-datasets
#' @examples
#' head(isic_classification)
"isic_classification"



#' @inherit isic_classification title
#' @inherit isic_classification description
#'
#' @section Definitions:
#' `r define("nace_classification")`
#'
#' @template info_classification-datasets
#'
#' @family datasets for bridging sector classification codes
#' @seealso [data_dictionary].
#'
#' @examples
#' head(nace_classification)
"nace_classification"



#' @inherit isic_classification title
#' @inherit isic_classification description
#'
#' @section Definitions:
#' `r define("naics_classification")`
#'
#' @template info_classification-datasets
#'
#' @family datasets for bridging sector classification codes
#' @seealso [data_dictionary].
#'
#' @examples
#' head(naics_classification)
"naics_classification"
