library(usethis)

source(file.path("data-raw", "utils.R"))

# Source: Conversation between @jdhoffa and @2diiKlaus on May 26
# NOTE to 2dii internals: if you wish to set different specifications
# for high-carbon/ low-carbon technologies, do so in this dataset

path <- file.path("data-raw", "increasing_or_decreasing.csv")
increasing_or_decreasing <- read_csv_(path)

increasing_or_decreasing <- increasing_or_decreasing %>%
  dplyr::filter(!grepl("hdv", technology))

increasing_or_decreasing_hdv <- increasing_or_decreasing %>%
  dplyr::filter(sector == "automotive") %>%
  dplyr::mutate(sector = "hdv")

increasing_or_decreasing <- increasing_or_decreasing %>%
  dplyr::bind_rows(increasing_or_decreasing_hdv)

usethis::use_data(increasing_or_decreasing, overwrite = TRUE)
