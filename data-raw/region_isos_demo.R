library(dplyr)

picked <-c(
  "advanced economies",
  "caspian",
  "developing asia",
  "europe",
  "global"
)

region_isos_demo <- r2dii.data::region_isos %>%
  mutate(source = "demo_2020") %>%
  filter(.data$region %in% picked)

length_ok <- identical(length(unique(region_isos_demo$region)), length(picked))
stopifnot(length_ok)

use_data(region_isos_demo, overwrite = TRUE)
