library(dplyr)

set.seed(1)

full <- unique(r2dii.data::region_isos$region)
ensure <- c("global", "europe")
random <- sample(setdiff(full, ensure), 3L)
picked <- c(ensure, random)

region_isos_demo <- r2dii.data::region_isos %>%
  mutate(source = "demo_2020") %>%
  filter(.data$region %in% picked)

length_ok <- identical(length(unique(region_isos_demo$region)), length(picked))
stopifnot(length_ok)

use_data(region_isos_demo, overwrite = TRUE)
