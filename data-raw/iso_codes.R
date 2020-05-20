library(readr)
library(usethis)

source(file.path("data-raw", "utils.R"))

# Source: @jdhoffa
path <- file.path("data-raw", "iso_codes.csv")
iso_codes <- remove_spec(readr::read_csv(path))

usethis::use_data(iso_codes, overwrite = TRUE)
