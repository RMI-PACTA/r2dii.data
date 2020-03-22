#' Column definitions of all datasets
#'
#' This dataset provides metadata about all datasets in the package r2dii.data.
#'
#' @family meta
#'
#' @format
#' `data_dictionary` is a [data.frame] with columns:
#' * `column` (character): The name of a dataset-column.
#' * `dataset` (character): The name of a dataset.
#' * `definition` (character): The definition of a dataset-column.
#' * `typeof` (character): The result of `typeof()`, one of double, integer,
#' logical, or character.
#'
#' @examples
#' head(data_dictionary)
"data_dictionary"
