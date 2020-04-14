source(here::here("data-raw/utils.R"))

path <- here::here("data-raw/ald_demo.csv")
ald_demo <- remove_spec(readr::read_csv(path))

usethis::use_data(ald_demo, overwrite = TRUE)
