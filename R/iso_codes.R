#' A dataset linking country names with their ISO code
#'
#' @template info_general
#' @template info_iso-codes
#' @description
#' This is a dataset useful when mapping regional benchmarks to countries.
#'
#' @family demo datasets
#' @family iso codes
#' @seealso [data_dictionary]
#'
#' @format
#' `iso_codes` is a [data.frame] with columns:
#' * `country` (character): Country name.
#' * `country_iso` (character): Corresponding ISO code.
#'
#' @examples
#' head(iso_codes)
"iso_codes"
