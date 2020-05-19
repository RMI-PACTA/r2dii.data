# packageVersion("dplyr")
# > [1] '0.8.99.9002'
library(dplyr)
library(readr)
library(here)
library(usethis)

# Functions ---------------------------------------------------------------

source(here::here("data-raw/utils.R"))

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
  ald_scenario <- inner_join(
    ald, mutate(scenario, scenario_source = scenario_source),
    by = c(ald_sector = "sector", technology = "technology", year = "year")
  ) %>%
    mutate(ald_location = tolower(.data$ald_location))

  # pick ald location in region
  inner_join(
    ald_scenario, region_isos,
    by = c("region", "ald_location" = "isos")
  ) %>%
    rename(scenario_region = region) %>%
    mutate(ald_company_sector_id = group_indices(group_by(., id, ald_sector)))
}

# Create ald_scenario_demo ------------------------------------------------

ald_demo <- remove_spec(readr::read_csv(here::here("data-raw/ald_demo.csv")))

ald_scenario_region <- join_ald_scenario_region(
  ald = rename_ald(ald_demo),
  scenario = r2dii.data::scenario_demo_2020,
  scenario_source = "demo_2020",
  region_isos = r2dii.data::region_isos
)

ald_scenario_demo <- ald_scenario_region %>%
  add_emission_factor_unit(new_emission_factor_unit()) %>%
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

usethis::use_data(ald_scenario_demo, overwrite = TRUE)
