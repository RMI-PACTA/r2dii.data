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

scenario_demo_2020_with_source <- r2dii.data::scenario_demo_2020 %>%
  dplyr::mutate(scenario_source = "DEMO2020")

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

usethis::use_data(ald_scenario_demo, overwrite = TRUE)
