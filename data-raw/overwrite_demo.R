library(readr)
library(usethis)

source(file.path("data-raw", "utils.R"))

# Source: @jdhoffa
path <- file.path("data-raw", "overwrite_demo.csv")
overwrite_demo <- remove_spec(read_a_csv(path))

usethis::use_data(overwrite_demo, overwrite = TRUE)
