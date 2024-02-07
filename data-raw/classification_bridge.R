library(usethis)

source(file.path("data-raw", "utils.R"))

nace_classification <- read_bridge(
  file.path("data-raw", "nace_classification.csv")
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
