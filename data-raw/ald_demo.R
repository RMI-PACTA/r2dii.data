library(here)
library(dplyr)
library(usethis)

source(here::here("data-raw/utils.R"))

path <- here::here("data-raw/ald_demo.csv")
ald_demo <- remove_spec(readr::read_csv(path))

ald_demo <- dplyr::left_join(
  ald_demo, new_emission_factor_unit(), by = "sector"
)

usethis::use_data(ald_demo, overwrite = TRUE)
