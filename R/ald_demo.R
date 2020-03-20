#' An asset level dataset for demonstration
#'
#' @template info_general
#' @template info_demo-datasets
#' @description This is a public dataset that may be used for examples and
#'   tests.
#'
#' @family demo datasets
#' @seealso [data_dictionary]
#'
#' @return
#' A [data.frame] with columns:
#' * `ald_timestamp` (character): Date at which asset data was pulled from
#' database.
#' * `country_of_domicile` (character): Country where company is registered.
#' * `emission_factor` (double): Company level emission factor of the
#' technology.
#' * `is_ultimate_listed_owner` (logical): Flag if company is the listed
#' ultimate parent.
#' * `is_ultimate_owner` (logical): Flag if company is the ultimate parent in
#' our database.
#' * `name_company` (character): The name of the company owning the asset.
#' * `number_of_assets` (integer): Number of assets of a given technology owned
#' by the company.
#' * `plant_location` (character): Country where asset is located.
#' * `production` (double): Company level production of the technology.
#' * `production_unit` (character): The units that production is measured in.
#' * `sector` (character): Sector to which the asset belongs.
#' * `technology` (character): Technology implemented by the asset.
#' * `year` (integer): Year at which the production value is predicted.
#'
#' @examples
#' head(ald_demo)
"ald_demo"
