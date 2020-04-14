source(here::here("data-raw/utils.R"))

# Source: @jdhoffa https://github.com/2DegreesInvesting/r2dii.dataraw/pull/6
isic_classification <- remove_spec(
  readr::read_csv(here::here("data-raw", "isic_classification.csv"))
)
use_data(isic_classification, overwrite = TRUE)

nace_classification <- remove_spec(
  readr::read_csv(here::here("data-raw", "nace_classification.csv"))
)
use_data(nace_classification, overwrite = TRUE)

naics_classification <- remove_spec(
  readr::read_csv(here::here("data-raw", "nace_classification.csv"))
)
use_data(naics_classification, overwrite = TRUE)
