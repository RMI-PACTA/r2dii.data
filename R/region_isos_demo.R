#' @inherit region_isos title
#'
#' @description
#' This dataset maps codes representing countries to regions. It is similar to
#' but smaller than [region_isos].
#'
#' @template info_demo-datasets
#' @template info_iso-codes
#'
#' @family iso codes
#' @family demo datasets
#'
#' @format
#' `region_isos` is a [data.frame] with columns:
#' * `isos` (character): Countries in region, defined by iso code.
#' * `region` (character): Benchmark region name.
#' * `source` (character): Source publication from which the regions are
#' defined.
#'
#' @examples
#'region_isos_demo
"region_isos_demo"
