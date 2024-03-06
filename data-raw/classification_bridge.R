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

isic_classification_raw <- read_csv_(
  file.path("data-raw", "isic_classification_rev_5.csv")
)

isic_classification <- prepend_letter_isic_code(
  isic_classification_raw,
  col_from = "ISIC Rev 5 Code",
  col_to = "code"
)

isic_classification <- dplyr::mutate(
  isic_classification,
  sector = dplyr::case_when(
    grepl("^B05", code) ~ "coal",
    grepl("^B06", code) ~ "oil and gas",
    grepl("^B091", code) ~ "oil and gas", # borderline
    grepl("^B099", code) ~ "coal", # borderline
    grepl("^C2394", code) ~ "cement",
    grepl("^C2395", code) ~ "cement", # borderline
    grepl("^C241", code) ~ "steel",
    grepl("^C2431", code) ~"steel", # borderline
    grepl("^C291", code) ~ "automotive", # borderline
    grepl("^C292", code) ~ "automotive", # borderline
    grepl("^C293", code) ~ "automotive", # borderline
    grepl("^D351", code) ~ "power", # some of these are borderline
    grepl("^H50", code) ~ "shipping",
    grepl("^H51", code) ~ "aviation",
    TRUE ~ "not in scope"
    ),
  borderline = dplyr::case_when(
    grepl("^B091", code) ~ TRUE,
    grepl("^B099", code) ~ TRUE,
    grepl("^C2395", code) ~ TRUE,
    grepl("^C2431", code) ~ TRUE,
    grepl("^C291", code) ~ TRUE,
    grepl("^C292", code) ~ TRUE,
    grepl("^C293", code) ~ TRUE,
    code == "D351" ~ TRUE,
    grepl("^D3513", code) ~ TRUE,
    TRUE ~ FALSE
  ),
)

isic_classification <- dplyr::mutate(
  isic_classification,
  revision = "5"
)

usethis::use_data(isic_classification, overwrite = TRUE)
