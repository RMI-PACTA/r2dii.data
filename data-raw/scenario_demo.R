library(dplyr)

# Accessed on 2020-03-12, source r2dii.dataraw::scenario_demo
# Source: @jdhoffa
path <- here::here("data-raw/scenario_demo.csv")

scenario <- readr::read_csv(path) %>%
  # remotes::install_github("2degreesinvesting/r2dii.scenario@0.0.0.9002")
  r2dii.scenario::add_market_share_columns(start_year = 2020) %>%
  dplyr::select(-c("value", "units"))

source(here::here("data-raw/utils.R"))
check_no_spec(scenario)

scenario_demo_2020 <- mutate(scenario, scenario_source = "demo_2020")
usethis::use_data(scenario_demo_2020, overwrite = TRUE)
