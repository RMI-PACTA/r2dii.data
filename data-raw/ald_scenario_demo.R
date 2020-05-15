# packageVersion("dplyr")
# > [1] '0.8.99.9002'
library(dplyr)
library(readr)
library(here)
library(usethis)

# Functions ---------------------------------------------------------------

rename_ald <- function(ald) {
  # Rename columns of ald_demo as per @2diiKlaus's comment
  # https://github.com/2DegreesInvesting/r2dii.data/pull/24#issuecomment-606408655
  new_names_from_old_names <- c(
      "id" = "name_company",
      "ald_sector" = "sector",
      "technology" = "technology",
      "ald_production_unit" = "production_unit",
      "year" = "year",
      "ald_production" = "production",
      "ald_emission_factor" = "emission_factor",
      "domicile_region" = "country_of_domicile",
      "ald_location" = "plant_location",
      "is_ultimate_owner" = "is_ultimate_owner"
    )

  ald %>%
    rename(all_of(new_names_from_old_names)) %>%
    select(-c(
      "number_of_assets",
      "is_ultimate_listed_owner",
      "ald_timestamp"
    )) %>%
    mutate(id_name = "company_name", .before = 1L) %>%
    mutate(
      ald_emission_factor_unit = glue::glue("{ald_sector} emission_factor"),
      .after = ald_emission_factor
    )
}

join_ald_scenario_region <- function(ald,
                                     scenario,
                                     scenario_source,
                                     region_isos) {
  inner_join(
    ald, mutate(scenario, scenario_source = scenario_source),
    by = c(ald_sector = "sector", technology = "technology", year = "year")
  ) %>%

  # pick ald location in region
  mutate(ald_location = tolower(.data$ald_location)) %>%
  inner_join(region_isos, by = c("region", "ald_location" = "isos")) %>%

  # Add or rename columns
  rename(scenario_region = region) %>%
  mutate(ald_company_sector_id = group_indices(group_by(., id, ald_sector)))
}

add_emission_factor_units <- function(data) {
  # styler: off
  co2_per <- function(x) paste("tons of CO2 per", x)
  emission_factor_units_per_technology <- tibble::tribble(
    ~technology,     ~ald_emission_factor_unit,
    "hydrocap",      co2_per("hour per MW"),
    "renewablescap", co2_per("hour per MW"),
    "oil",           co2_per("GJ"),
    "gas",           co2_per("GJ"),
    "coal",          co2_per("tons of coal"),
    "electric",      co2_per("km per cars produced"),
    "hybrid",        co2_per("km per cars produced"),
    "ice",           co2_per("km per cars produced"),
    "coalcap",       co2_per("hour per MW"),
    "gascap",        co2_per("hour per MW"),
    "oilcap",        co2_per("hour per MW"),
    "nuclearcap",    co2_per("hour per MW"),
  )
  # styler: on

  data %>%
    select(-.data$ald_emission_factor_unit) %>%
    left_join(emission_factor_units_per_technology, by = "technology") %>%
    select(
      .data$ald_company_sector_id,
      .data$id_name,
      .data$id,
      .data$ald_sector,
      .data$ald_location,
      .data$technology,
      .data$year,
      .data$ald_production,
      .data$ald_production_unit,
      .data$ald_emission_factor,
      .data$ald_emission_factor_unit,
      .data$domicile_region,
      .data$is_ultimate_owner,
      .data$scenario_source,
      .data$scenario,
      .data$scenario_region,
      .data$tmsr,
      .data$smsp
    )
}

# Create ald_scenario_demo ------------------------------------------------

source(here::here("data-raw/utils.R"))
ald_demo <- remove_spec(readr::read_csv(here::here("data-raw/ald_demo.csv")))

ald_scenario_region <-join_ald_scenario_region(
  ald = rename_ald(ald_demo),
  scenario = r2dii.data::scenario_demo_2020,
  scenario_source = "demo_2020",
  region_isos = r2dii.data::region_isos
)

ald_scenario_demo <- add_emission_factor_units(ald_scenario_region)
usethis::use_data(ald_scenario_demo, overwrite = TRUE)
