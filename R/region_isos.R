#' A dataset outlining various region definitions
#'
#' @description
#' This dataset maps codes representing countries to regions.
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
