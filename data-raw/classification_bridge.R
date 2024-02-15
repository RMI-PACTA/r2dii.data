library(dplyr)
library(usethis)

source(file.path("data-raw", "utils.R"))

nace_classification_raw <- read_bridge(
  file.path("data-raw", "nace_classification.csv")
)

nace_classification <- convert_superseded_nace_code(
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
