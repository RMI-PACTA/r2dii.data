library(dplyr)
library(rlang)
library(usethis)

source(file.path("data-raw", "utils.R"))

# add_market_share_columns ------------------------------------------------

add_market_share_columns <- function(scenario, start_year) {
  stopifnot(is.data.frame(scenario), is.numeric(start_year))

  old_groups <- dplyr::groups(scenario)
  scenario <- dplyr::ungroup(scenario)

  abort_invalid_start_year(start_year)
  if (is.na(start_year)) {
    rlang::warn("`start_year` is NA.", class = "missing_start_year")
    return(cero_row_fair_share_tibble(scenario, old_groups))
  }
  check_crucial_names(scenario, crucial_fs_columns())
  check_consistent_units(scenario)

  scenario %>%
    dplyr::filter(.data$year >= round_start_year(start_year)) %>%
    add_technology_fair_share_ratio() %>%
    add_market_fair_share_percentage() %>%
    dplyr::group_by(!!!old_groups)
}

abort_invalid_start_year <- function(start_year) {
  if (!all(is.na(start_year)) && (length(start_year) != 1 || start_year <= 0L)) {
    rlang::abort(
      class = "invalid_start_year",
      message = "`start_year` must be of length 1 and greater than cero."
    )
  }

  invisible(start_year)
}

cero_row_fair_share_tibble <- function(scenario, old_groups) {
  minimum_names_add_scenario_fair_share(scenario) %>%
    named_tibble() %>%
    dplyr::group_by(!!!old_groups)
}

crucial_fs_columns <- function() {
  c(
    common_fs_groups(),
    "technology",
    "year",
    "value",
    "units"
  )
}

common_fs_groups <- function() {
  c("scenario", "sector", "region")
}

check_consistent_units <- function(scenario) {
  units <- scenario %>%
    dplyr::group_by(!!!syms(c(common_fs_groups(), "technology"))) %>%
    dplyr::summarise(are_consistent = (length(unique(units)) == 1L))

  if (all(units$are_consistent)) {
    return(invisible(scenario))
  }

  bad <- dplyr::ungroup(dplyr::filter(units, !.data$are_consistent))
  rlang::abort(
    class = "inconsistent_units",
    message = glue::glue(
      "`scenario` must have consistent `units` per each `technology` group.
      Technologies with inconsistent units: {commas(bad$technology)}"
    )
  )
}

round_start_year <- function(start_year) {
  if (start_year %% 1 != 0L) {
    start_year <- round(start_year)
    rlang::warn(
      class = "not_round_start_year",
      message = "Rounding `start_year`: {start_year}.",
    )
  }

  start_year
}

add_technology_fair_share_ratio <- function(scenario) {
  scenario %>%
    dplyr::ungroup() %>%
    dplyr::group_by(!!!syms(c(common_fs_groups(), "technology"))) %>%
    dplyr::arrange(.data$year, .by_group = TRUE) %>%
    dplyr::mutate(tmsr = .data$value / dplyr::first(.data$value)) %>%
    dplyr::ungroup()
}

add_market_fair_share_percentage <- function(scenario) {
  scenario %>%
    dplyr::ungroup() %>%
    dplyr::group_by(!!!syms(c(common_fs_groups(), "year"))) %>%
    dplyr::arrange(.data$year, .by_group = TRUE) %>%
    dplyr::mutate(sector_total_by_year = sum(.data$value)) %>%
    dplyr::group_by(!!!syms(c(common_fs_groups(), "technology"))) %>%
    dplyr::mutate(
      smsp = (.data$value - dplyr::first(.data$value)) /
        dplyr::first(.data$sector_total_by_year),
      sector_total_by_year = NULL
    ) %>%
    dplyr::ungroup()
}

named_tibble <- function(names) {
  dplyr::slice(tibble::as_tibble(rlang::set_names(as.list(names))), 0L)
}

minimum_names_add_scenario_fair_share <- function(scenario) {
  unique(c(names(scenario), names_added_by_add_scenario_fair_share()))
}

names_added_by_add_scenario_fair_share <- function() {
  c(
    "tmsr",
    "smsp"
  )
}

commas <- function(...) paste0(..., collapse = ", ")




# Use data ----------------------------------------------------------------

# Accessed on 2020-03-12, source r2dii.dataraw::scenario_demo
# Source: @jdhoffa
path <- file.path("data-raw", "scenario_demo.csv")

scenario <- read_csv_(path) %>%
  add_market_share_columns(start_year = 2020) %>%
  dplyr::select(-c("value", "units"))

source(file.path("data-raw", "utils.R"))
check_no_spec(scenario)

scenario_demo_2020 <- mutate(scenario, scenario_source = "demo_2020")
scenario_demo_2020$year <- as.integer(scenario_demo_2020$year)

usethis::use_data(scenario_demo_2020, overwrite = TRUE)
