library(dplyr)
library(usethis)

source(file.path("data-raw", "utils.R"))

path <- file.path("data-raw", "ald_demo.csv")
ald_demo <- read_csv_(path)

ald_demo <- dplyr::left_join(
  ald_demo, new_emission_factor_unit(), by = "sector"
)

usethis::use_data(ald_demo, overwrite = TRUE)
