library(usethis)

source(file.path("data-raw", "utils.R"))

# Source: @jdhoffa
path <- file.path("data-raw", "iso_codes.csv")
iso_codes <- read_csv_(path)

usethis::use_data(iso_codes, overwrite = TRUE)
