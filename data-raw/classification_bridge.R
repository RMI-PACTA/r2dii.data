library(usethis)

source(file.path("data-raw", "utils.R"))

# Source: @jdhoffa https://github.com/2DegreesInvesting/r2dii.dataraw/pull/6
isic_classification <- read_csv_(
  file.path("data-raw", "isic_classification.csv")
)
use_data(isic_classification, overwrite = TRUE)

nace_classification <- read_csv_(
  file.path("data-raw", "nace_classification.csv")
)
use_data(nace_classification, overwrite = TRUE)

naics_classification <- read_csv_(
  file.path("data-raw", "nace_classification.csv")
)
usethis::use_data(naics_classification, overwrite = TRUE)

manual_classification <- read_csv_(
  file.path("data-raw", "manual_classification.csv")
)
usethis::use_data(manual_classification, overwrite = TRUE)
