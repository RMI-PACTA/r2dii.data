source(here::here("data-raw", "add_market_share_columns.R"))

library(magrittr)

# Accessed on 2020-03-12, source r2dii.dataraw::scenario_demo
# Source: @jdhoffa
path <- here::here("data-raw/scenario_demo.csv")

scenario_demo_2020 <- readr::read_csv(path) %>%
  add_market_share_columns(start_year = 2020) %>%
  dplyr::select(-c("value", "units"))

usethis::use_data(scenario_demo_2020, overwrite = TRUE)
