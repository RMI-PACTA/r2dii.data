#' Asset level data connected to prepared scenario data for demonstration
#'
#' @description This dataset is the starting point of any PACTA analysis,
#' including the bank's methodology. It can be used for matching as well as for
#' the analysis itself. The dataset includes the asset level data connected to
#' a scenario dataset, having prepared technology market share and sector market
#' share values.
#'
#' @template info_demo-datasets
#'
#' @family demo datasets
#' @seealso [data_dictionary]
#'
#' @format
#' `ald_scenario_demo` is a [data.frame] with columns:
#' * `ald_company_sector_id` (integer): Company ID allocated by 2dii. Each ID is unique per sector and company name.
#' * `ald_emission_factor` (double): Company level emission factor of the technology.
#' * `ald_emission_factor_unit` (character): The units that the emission factor is measured in.
#' * `ald_location` (character): Country where asset is located.
#' * `ald_production` (double): Company level production of the technology.
#' * `ald_production_unit` (character): The units that production is measured in.
#' * `ald_sector` (character): Sector to which the asset belongs.
#' * `domicile_region` (character): Country where company is registered.
#' * `id` (character): The financial instrument-specific id that defines the company (or corporate bond pool).
#' * `id_name` (character): Name of the ID provided in the id column. The id is used for mapping of the dataset to a given portfolio (for credit: company_name for corporate bonds: corporate_ticker for equity: bloomberg_id).
#' * `is_ultimate_owner` (logical): Flag if company is the ultimate parent in our database.
#' * `scenario` (character): Abbreviation of the scenario pathway name (e.g. Sustainable Development Scenario is sds).
#' * `scenario_region` (character): The region of the production (from the asset location). It is aggregated to the regions given by the scenarios to allow the application of the regional scenario pathway.
#' * `scenario_source` (character): The source publication from which the scenario was taken.
#' * `smsp` (double): Sector market share percentage.
#' * `technology` (character): Technology implemented by the asset.
#' * `tmsr` (double): Technology market share ratio.
#' * `year` (integer): Year at which the production value is predicted.
#'
#' @examples
#' head(ald_scenario_demo)
"ald_scenario_demo"
