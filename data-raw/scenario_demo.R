# Source: @jdhoffa
path <- here::here("data-raw/scenario_demo.csv")
scenario_demo <- readr::read_csv(path)

usethis::use_data(scenario_demo, overwrite = TRUE)
