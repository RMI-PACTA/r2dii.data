path <- here::here("data-raw/ald_demo.csv")
ald_demo <- readr::read_csv(path)

# See #22
# ald_demo$is_ultimate_owner <- NULL
# readr::write_csv(ald_demo, path)

usethis::use_data(ald_demo, overwrite = TRUE)
