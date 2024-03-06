library(dplyr)
library(usethis)

source(file.path("data-raw", "utils.R"))

nace_classification_raw <- read_bridge(
  file.path("data-raw", "nace_classification.csv")
)

nace_classification <- prepend_letter_nace_code(
  nace_classification_raw,
  col_from = "original_code",
  col_to = "code"
)

use_data(nace_classification, overwrite = TRUE)

naics_classification <- read_bridge(
  file.path("data-raw", "naics_classification.csv")
)
usethis::use_data(naics_classification, overwrite = TRUE)

sic_classification <- read_bridge(
  file.path("data-raw", "sic_classification.csv")
)
usethis::use_data(sic_classification, overwrite = TRUE)

gics_classification <- read_bridge(
  file.path("data-raw", "gics_classification.csv")
)
usethis::use_data(gics_classification, overwrite = TRUE)

psic_classification <- read_bridge(
  file.path("data-raw", "psic_classification.csv")
)
usethis::use_data(psic_classification, overwrite = TRUE)

isic_classification_raw <- read_bridge(
  file.path("data-raw", "isic_classification.csv")
)

isic_classification <- prepend_letter_nace_code(
  isic_classification_raw,
  isic_rev_5_raw,
  col_from = "ISIC Rev 5 Code",
  col_to = "code"
)

isic_classification <- dplyr::mutate(
  isic_classification,
  revision = "5"
)

usethis::use_data(isic_classification, overwrite = TRUE)
