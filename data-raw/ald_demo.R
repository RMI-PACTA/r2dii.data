library(dplyr)
library(usethis)

source(file.path("data-raw", "utils.R"))

path <- file.path("data-raw", "ald_demo.csv")
ald_demo <- read_csv_(path)

ald_demo <- left_join(
  ald_demo, new_emission_factor_unit(),
  by = "sector"
)

ald_demo$year <- as.integer(ald_demo$year)

ald_demo <- ald_demo %>%
  group_by(name_company) %>%
  mutate(
    id_company = as.character(cur_group_id()),
    .before = 1
  ) %>%
  ungroup()

usethis::use_data(ald_demo, overwrite = TRUE)
