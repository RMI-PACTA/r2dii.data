#' A dataset outlining various region definitions (using iso codes)
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
#' `region_isos` is a [data.frame] with columns:
#' * `isos` (character): Countries in region, defined by iso code.
#' * `region` (character): Benchmark region name.
#'
#' @examples
#' head(region_isos)
"region_isos"
