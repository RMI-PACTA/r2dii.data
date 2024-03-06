library(usethis)

source(file.path("data-raw", "utils.R"))

# Source: Conversation between @jdhoffa and @2diiKlaus on May 26
# NOTE to 2dii internals: if you wish to set different specifications
# for high-carbon/ low-carbon technologies, do so in this dataset

path <- file.path("data-raw", "green_or_brown.csv")
green_or_brown <- read_csv_(path)

green_or_brown <- green_or_brown %>%
  dplyr::filter(!grepl("hdv", technology))

green_or_brown_hdv <- green_or_brown %>%
  dplyr::filter(sector == "automotive") %>%
  dplyr::mutate(sector = "hdv")

legacy_green_or_brown <- green_or_brown %>%
  dplyr::bind_rows(green_or_brown_hdv)

# Deprecated cnb_classification
cnb_classification_ <- read_bridge(
  file.path("data-raw", "cnb_classification.csv")
)

usethis::use_data(
  legacy_green_or_brown,
  cnb_classification_,
  overwrite = TRUE,
  internal = TRUE
)
