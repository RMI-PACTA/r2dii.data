source(here::here("data-raw/utils.R"))

# Functions ---------------------------------------------------------------
new_names_from_old_names <- function(){
  c(
    "id" = "name_company",
    "ald_sector" = "sector",
    "technology" = "technology",
    "ald_production_unit" = "production_unit",
    "year" = "year",
    "ald_production" = "production",
    "ald_emission_factor" = "emission_factor",
    "country_of_domicile" = "country_of_domicile",
    "ald_location" = "ald_location",
    "FIXME_number_of_assets" = "number_of_assets",
    "is_ultimate_owner" = "is_ultimate_owner",
    "FIXME_is_ultimate_listed_owner" = "is_ultimate_listed_owner",
    "FIXME_ald_timestamp" = "ald_timestamp"
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
  data %>% dplyr::mutate(ald_location = tolower(.data$ald_location)) %>%
    dplyr::inner_join(r2dii.data::region_isos,
                      by = c("region", "ald_location" = "isos")
    )
}

# Rename columns of ald_demo as per @2diiKlaus's comment ------------------
# https://github.com/2DegreesInvesting/r2dii.data/pull/24#issuecomment-606408655
path <- here::here("data-raw/ald_demo.csv")
ald_demo <- remove_spec(readr::read_csv(path))

# packageVersion("dplyr")
# > [1] '0.8.99.9002'
ald_scenario_demo <- ald_demo %>%
  dplyr::rename(dplyr::all_of(new_names_from_old_names())) %>%
  dplyr::mutate(id_name = "company_name", .before = 1L) %>%
  dplyr::mutate(
    ald_emission_factor_unit = glue::glue("{ald_sector} emission_factor"),
    .after = ald_emission_factor
  ) %>%
  dplyr::inner_join(r2dii.data::scenario_demo_2020, by = scenario_columns()) %>%
  pick_ald_location_in_region()

usethis::use_data(ald_scenario_demo, overwrite = TRUE)

# Data dictionary ---------------------------------------------------------

tibble::tibble(
  new_column = names(new_names_from_old_names),
  old_column = unname(new_names_from_old_names)
) %>%
  dplyr::right_join(tibble::tibble(new_column = names(ald_scenario_demo))) %>%
  dplyr::left_join(data_dictionary, by = c("old_column" = "column")) %>%
  dplyr::filter(is.na(dataset) | dataset %in% c("ald_demo", "scenario_demo_2020")) %>%
  dplyr::arrange(old_column, dataset) %>%
  # FIXME: Integrate with what Klaus defined at:
  # https://github.com/2DegreesInvesting/r2dii.data/issues/32#issue-590822964
  readr::write_csv("data-raw/data_dictionary/WIP_ald_senario_demo.csv")
