source(here::here("data-raw/utils.R"))

path <- here::here("data-raw/ald_demo.csv")
ald_demo <- remove_spec(readr::read_csv(path))

ald_demo <- ald_demo %>%
  dplyr::left_join(new_emission_factor_unit(), by = "sector")

usethis::use_data(ald_demo, overwrite = TRUE)
