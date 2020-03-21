#' A dataset outlining various region definitions (using iso codes)
#'
#' @description
#' This is a dataset useful when mapping regional benchmarks to countries.
#' @template info_iso-codes
#'
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
