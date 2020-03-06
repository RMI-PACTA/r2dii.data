# Source: @jdhoffa
path <- here::here("data-raw/iso_codes.csv")
iso_codes <- readr::read_csv(path)

usethis::use_data(iso_codes, overwrite = TRUE)
