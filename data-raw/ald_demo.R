source(here::here("data-raw/utils.R"))

path <- here::here("data-raw/ald_demo.csv")
ald_demo <- remove_spec(readr::read_csv(path))

ald_demo <- ald_demo %>%
  add_emission_factor_unit2(new_emission_factor_unit())

usethis::use_data(ald_demo, overwrite = TRUE)
