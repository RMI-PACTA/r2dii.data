library(usethis)
library(here)

source(here("data-raw", "utils.R"))

# Source: @jdhoffa https://github.com/2DegreesInvesting/r2dii.dataraw/pull/6
isic_classification <- read_csv_(
  here("data-raw", "isic_classification.csv")
)
use_data(isic_classification, overwrite = TRUE)

nace_classification <- read_csv_(
  here("data-raw", "nace_classification.csv")
)
use_data(nace_classification, overwrite = TRUE)

naics_classification <- read_csv_(
  here("data-raw", "naics_classification.csv")
)
usethis::use_data(naics_classification, overwrite = TRUE)

sic_classification <- read_csv_(
  here("data-raw", "sic_classification.csv")
)
usethis::use_data(sic_classification, overwrite = TRUE)

gics_classification <- read_csv_(
  here("data-raw", "gics_classification.csv")
)
usethis::use_data(gics_classification, overwrite = TRUE)

cnb_classification <- read_csv_(
  here("data-raw", "cnb_classification.csv")
)
usethis::use_data(cnb_classification, overwrite = TRUE)
