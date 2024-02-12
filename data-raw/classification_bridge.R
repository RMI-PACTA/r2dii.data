library(usethis)

source(file.path("data-raw", "utils.R"))

# Source: @jdhoffa https://github.com/2DegreesInvesting/r2dii.dataraw/pull/6
isic_classification <- read_bridge(
  file.path("data-raw", "isic_classification.csv")
)
use_data(isic_classification, overwrite = TRUE)

nace_classification_raw <- read_bridge(
  file.path("data-raw", "nace_classification.csv")
)

nace_classification <- nace_classification_raw %>%
  mutate(
    prepend_value = case_when(
      original_code %in% LETTERS ~ "",
      trunc(as.numeric(original_code)) %in% seq(1, 3) ~ "A",
      trunc(as.numeric(original_code)) %in% seq(5, 9) ~ "B",
      trunc(as.numeric(original_code)) %in% seq(10, 33) ~ "C",
      trunc(as.numeric(original_code)) == 35 ~ "D",
      trunc(as.numeric(original_code)) %in% seq(36, 39) ~ "E",
      trunc(as.numeric(original_code)) %in% seq(41, 43) ~ "F",
      trunc(as.numeric(original_code)) %in% seq(45, 47) ~ "G",
      trunc(as.numeric(original_code)) %in% seq(49, 53) ~ "H",
      trunc(as.numeric(original_code)) %in% seq(55, 56) ~ "I",
      trunc(as.numeric(original_code)) %in% seq(58, 63) ~ "J",
      trunc(as.numeric(original_code)) %in% seq(64, 66) ~ "K",
      trunc(as.numeric(original_code)) == 68 ~ "L",
      trunc(as.numeric(original_code)) %in% seq(69, 75) ~ "M",
      trunc(as.numeric(original_code)) %in% seq(77, 82) ~ "N",
      trunc(as.numeric(original_code)) == 84 ~ "O",
      trunc(as.numeric(original_code)) == 85 ~ "P",
      trunc(as.numeric(original_code)) %in% seq(86, 88) ~ "Q",
      trunc(as.numeric(original_code)) %in% seq(90, 93) ~ "R",
      trunc(as.numeric(original_code)) %in% seq(94, 96) ~ "S",
      trunc(as.numeric(original_code)) %in% seq(97, 98) ~ "T",
      trunc(as.numeric(original_code)) == 99 ~ "U",
      TRUE ~ "Z" #debug value, see unit tests)
    )
  ) %>%
  mutate(
    code = paste0(prepend_value, original_code),
    prepend_value = NULL
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

cnb_classification <- read_bridge(
  file.path("data-raw", "cnb_classification.csv")
)
usethis::use_data(cnb_classification, overwrite = TRUE)

psic_classification <- read_bridge(
  file.path("data-raw", "psic_classification.csv")
)
usethis::use_data(psic_classification, overwrite = TRUE)
