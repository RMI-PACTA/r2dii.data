#' A demonstration dataset used to overwrite specific entity names or sectors
#'
#' Used to manually link loanbook entities to mismatched asset level entities.
#'
#' @family demo datasets
#' @seealso [data_dictionary]
#'
#' @format
#' `overwrite_demo` is a [data.frame] with columns:
#' * `id_2dii` (character): IDs of the entities to overwrite.
#' * `level` (character): Which level should be overwritten (e.g.
#' direct_loantaker or ultimate_parent).
#' * `name` (character): Overwrite name (if only overwriting sector, type NA).
#' * `sector` (character): Overwrite sector (if only overwriting name, type NA).
#' * `source` (character): What is the source of this information (leave as
#' "manual" for now, may remove this flag later).
#'
#' @examples
#' head(overwrite_demo)
"overwrite_demo"
