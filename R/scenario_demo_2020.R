#' A prepared climate scenario dataset for demonstration
#'
#' @description
#' Fake climate scenario dataset, prepared for the software PACTA (Paris
#' Agreement Capital Transition Assessment). It imitates climate scenario
#' provided by organizations such as the International Energy Agency (IEA) and
#' prepared by 2DII (<https://2degrees-investing.org/>) by calculating the
#' percent and ratio rates of change from the raw scenario production forecasts.
#' @template info_demo-datasets
#'
#' @family demo datasets
#' @seealso [data_dictionary]
#'
#' @format
#' `scenario_demo_2020` is a [data.frame] with columns:
#' * `region` (character): The region to which the pathway is relevant.
#' * `scenario` (character): The name of the scenario.
#' * `sector` (character): The sector to which the scenario prescribes a
#' pathway.
#' * `smsp` (double): Sector market share percentage of the pathway calculated
#' in 2020.
#' * `technology` (character): The technology within the sector to which the
#' scenario prescribes a pathway.
#' * `tmsr` (double): Technology market share ratio of the pathway calculated in
#' 2020.
#' * `year` (integer): The year at which the pathway value is prescribed.
#'
#' @examples
#' head(scenario_demo_2020)
"scenario_demo_2020"
