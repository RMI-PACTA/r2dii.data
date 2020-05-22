library(usethis)

source(file.path("data-raw", "utils.R"))

# Source: @jdhoffa
path <- file.path("data-raw", "overwrite_demo.csv")
overwrite_demo <- read_csv_(path)

usethis::use_data(overwrite_demo, overwrite = TRUE)
