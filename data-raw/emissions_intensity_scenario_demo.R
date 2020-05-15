source(here::here("data-raw/utils.R"))

path <- here::here("data-raw/emissions_intensity_scenario_demo.csv")
emissions_intensity_scenario_demo <- remove_spec(readr::read_csv(path))

usethis::use_data(emissions_intensity_scenario_demo, overwrite = TRUE)
