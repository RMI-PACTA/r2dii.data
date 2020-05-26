library(usethis)

source(file.path("data-raw", "utils.R"))
# Source: @jdhoffa <https://github.com/2DegreesInvesting/r2dii.data/issues/54>
path <- file.path("data-raw", "co2_intensity_scenario_demo.csv")
co2_intensity_scenario_demo <- read_csv_(path)

use_data(co2_intensity_scenario_demo, overwrite = TRUE)
