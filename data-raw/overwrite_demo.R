source(here::here("data-raw/utils.R"))

# Source: @jdhoffa
path <- here::here("data-raw/overwrite_demo.csv")
overwrite_demo <- remove_spec(readr::read_csv(path))

usethis::use_data(overwrite_demo, overwrite = TRUE)
