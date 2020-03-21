#' A view of available sector classification datasets
#'
#' @description
#' This dataset lists all sector classification code standards used by 'PACTA'
#' (<https://2degrees-investing.org/resource/pacta/>).
#' @template info_classification-datasets
#'
#' @family datasets for bridging sector classification codes
#' @seealso [data_dictionary].
#'
#' @format
#' `sector_classifications` is a [data.frame] with columns:
#' * `borderline` (character): Flag indicating if 2dii sector and classification
#' code are a borderline match.
#' * `code` (character): Formatted code.
#' * `code_system` (character): Code system.
#' * `sector` (character): Associated 2dii sector.
#'
#' @examples
#' head(sector_classifications)
"sector_classifications"
