# Source: @jdhoffa <https://github.com/2DegreesInvesting/r2dii.data/issues/54>
co2_intensity_scenario_demo <- readr::read_csv(here::here("data-raw", "co2_intensity_scenario.csv"))
use_data(co2_intensity_scenario_demo, overwrite = TRUE)
