# Source: @jdhoffa
path <- here::here("data-raw/overwrite_demo.csv")
overwrite_demo <- readr::read_csv(path)

usethis::use_data(overwrite_demo, overwrite = TRUE)
