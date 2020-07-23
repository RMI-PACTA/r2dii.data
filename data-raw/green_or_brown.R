library(usethis)

source(file.path("data-raw", "utils.R"))

# Source: Conversation between @jdhoffa and @2diiKlaus on May 26
# NOTE to 2dii internals: if you wish to set different specifications
# for high-carbon/ low-carbon technologies, do so in this dataset

path <- file.path("data-raw", "green_or_brown.csv")
green_or_brown <- read_csv_(path)

usethis::use_data(green_or_brown, overwrite = TRUE)
