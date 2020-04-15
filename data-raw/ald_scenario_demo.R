source(here::here("data-raw/utils.R"))

# Rename columns of ald_demo as per @2diiKlaus's comment ------------------
# https://github.com/2DegreesInvesting/r2dii.data/pull/24#issuecomment-606408655
path <- here::here("data-raw/ald_demo.csv")
ald_demo <- remove_spec(readr::read_csv(path))

new_names_from_old_names <- c(
  "id" = "name_company",
  "ald_sector" = "sector",
  "technology" = "technology",
  "ald_production_unit" = "production_unit",
  "year" = "year",
  "ald_production" = "production",
  "ald_emission_factor" = "emission_factor",
  "country_of_domicile" = "country_of_domicile",
  "ald_location" = "plant_location",
  "FIXME_number_of_assets" = "number_of_assets",
  "is_ultimate_owner" = "is_ultimate_owner",
  "FIXME_is_ultimate_listed_owner" = "is_ultimate_listed_owner",
  "FIXME_ald_timestamp" = "ald_timestamp"
)

# packageVersion("dplyr")
#> [1] '0.8.99.9002'
ald_scenario_demo <- ald_demo %>%
  dplyr::rename(dplyr::all_of(new_names_from_old_names)) %>%
  dplyr::mutate(id_name = "FIXME_id_name", .before = 1L) %>%
  dplyr::mutate(
    ald_emission_factor_unit = "FIXME_ald_emission_factor_unit",
    .after = ald_emission_factor
  )

ald_scenario_demo
