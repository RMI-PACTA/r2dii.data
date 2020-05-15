#' A climate scenario dataset for demonstration
#'
#' @description
#' Fake climate scenario dataset, prepared for the software PACTA (Paris
#' Agreement Capital Transition Assessment). It imitates climate scenario data
#' (e.g. from the International Energy Agency (IEA)) including the change
#' through time in production across industrial sectors (calculated by
#' [2DII](https://2degrees-investing.org/)). This dataset reflects the less
#' granular, global emissions intensity targets.
#' @template info_demo-datasets
#'
#' @family demo datasets
#' @seealso [data_dictionary]
#'
#' @format
#' `emissions_intensity_scenario_demo` is a [data.frame] with columns:
#' * `region` (character): The region to which the pathway is relevant.
#' * `scenario` (character): The name of the scenario.
#' * `scenario_source` (character): The source publication from which the scenario was taken.
#' * `sector` (character): The sector to which the scenario prescribes a pathway.
#' * `unit` (character): The unit of the value prescribed by the scenario.
#' * `value` (double): The value prescribed by the scenario.
#' * `year` (integer): The year at which the pathway value is prescribed.
#'
#' @examples
#' head(emissions_intensity_scenario_demo)
"emissions_intensity_scenario_demo"
