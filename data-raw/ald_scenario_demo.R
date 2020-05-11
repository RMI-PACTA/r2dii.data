library(dplyr)
library(readr)
library(here)
library(usethis)

source(here::here("data-raw/utils.R"))

# Functions ---------------------------------------------------------------
new_names_from_old_names <- function() {
  c(
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
}

scenario_columns <- function() {
  c(
    ald_sector = "sector",
    technology = "technology",
    year = "year"
  )
}

pick_ald_location_in_region <- function(data) {
  data %>%
    dplyr::mutate(ald_location = tolower(.data$ald_location)) %>%
    dplyr::inner_join(r2dii.data::region_isos,
      by = c("region", "ald_location" = "isos")
    )
}

# Rename columns of ald_demo as per @2diiKlaus's comment ------------------
# https://github.com/2DegreesInvesting/r2dii.data/pull/24#issuecomment-606408655
path <- here::here("data-raw/ald_demo.csv")
ald_demo <- remove_spec(readr::read_csv(path))

# packageVersion("r2dii.data")
# > [1] '0.0.3.9001'
scenario_demo_2020_with_source <- r2dii.data::scenario_demo_2020 %>%
  dplyr::mutate(scenario_source = "demo_2020")

# packageVersion("dplyr")
# > [1] '0.8.99.9002'
ald_scenario_demo <- ald_demo %>%
  dplyr::rename(dplyr::all_of(new_names_from_old_names())) %>%
  dplyr::select(-c(
    "number_of_assets",
    "is_ultimate_listed_owner",
    "ald_timestamp"
  )) %>%
  dplyr::mutate(id_name = "company_name", .before = 1L) %>%
  dplyr::mutate(
    ald_emission_factor_unit = glue::glue("{ald_sector} emission_factor"),
    .after = ald_emission_factor
  ) %>%
  dplyr::inner_join(scenario_demo_2020_with_source, by = scenario_columns()) %>%
  pick_ald_location_in_region() %>%
  dplyr::rename(scenario_region = region)

ald_scenario_demo <- ald_scenario_demo %>%
  dplyr::mutate(
    ald_company_sector_id =
      dplyr::group_indices(dplyr::group_by(., id, ald_sector))
  )

# Add emission_factor_units ---------------------------
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

ald_scenario_demo <- ald_scenario_demo %>%
  dplyr::select(-ald_emission_factor_unit) %>%
  dplyr::left_join(emission_factor_units_per_technology, by = "technology") %>%
  dplyr::select(
    ald_company_sector_id,
    id_name,
    id,
    ald_sector,
    ald_location,
    technology,
    year,
    ald_production,
    ald_production_unit,
    ald_emission_factor,
    ald_emission_factor_unit,
    domicile_region,
    is_ultimate_owner,
    scenario_source,
    scenario,
    scenario_region,
    tmsr,
    smsp
  )

usethis::use_data(ald_scenario_demo, overwrite = TRUE)
