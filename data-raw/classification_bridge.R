library(dplyr)
library(usethis)

source(file.path("data-raw", "utils.R"))

nace_classification_raw <- readr::read_tsv(
  file.path("data-raw", "NACE2.1_NACE2_Table.tsv")
)

nace_classification <- dplyr::distinct(
  nace_classification_raw,
  .data[["NACE21_CODE"]],
  .data[["LEVEL"]],
  .data[["NACE21_HEADING"]]
)

nace_classification <- prepend_letter_nace_code(
  nace_classification,
  col_from = "NACE21_CODE",
  col_to = "code"
)

nace_classification <- dplyr::mutate(
  nace_classification,
  sector = dplyr::case_when(
    grepl("^B05", code) ~ "coal",
    grepl("^B06", code) ~ "oil and gas",
    grepl("^B09.1", code) ~ "oil and gas", # borderline
    grepl("^B09.9", code) ~ "coal", # borderline
    .data$code == "C23.5" ~ "cement", # borderline
    grepl("^C23.51", code) ~ "cement",
    grepl("^C23.52", code) ~ "cement", # borderline
    grepl("^C23.6", code) ~ "cement", # borderline
    grepl("^C23.95", code) ~ "cement", # borderline
    grepl("^C24.1", code) ~ "steel",
    grepl("^C24.2", code) ~ "steel", # borderline
    grepl("^C24.3", code) ~ "steel", # borderline
    grepl("^C24.52", code) ~ "steel", # borderline
    grepl("^C29.1", code) ~ "automotive", # borderline
    grepl("^C29.2", code) ~ "automotive", # borderline
    grepl("^D35.1", code) ~ "power", # some of these are borderline
    grepl("^H50", code) ~ "shipping",
    grepl("^H51.1", code) ~ "aviation",
    TRUE ~ "not in scope"
  ),
  borderline = dplyr::case_when(
    grepl("^B09.1", code) ~ TRUE,
    grepl("^B09.9", code) ~ TRUE,
    .data$code == "C23.5" ~ TRUE,
    grepl("^C23.52", code) ~ TRUE,
    grepl("^C23.6", code) ~ TRUE,
    grepl("^C24.2", code) ~ TRUE,
    grepl("^C24.3", code) ~ TRUE,
    grepl("^C24.52", code) ~ TRUE,
    grepl("^C29.1", code) ~ TRUE,
    grepl("^C29.2", code) ~ TRUE,
    code == "D35.1" ~ TRUE,
    grepl("^D35.13", code) ~ TRUE,
    grepl("^D35.14", code) ~ TRUE,
    grepl("^D35.15", code) ~ TRUE,
    grepl("^D35.16", code) ~ TRUE,
    TRUE ~ FALSE
  ),
)

nace_classification <- dplyr::mutate(
  nace_classification,
  version = "2.1"
)

nace_classification <- dplyr::select(
  nace_classification,
  original_code = "NACE21_CODE",
  description = "NACE21_HEADING",
  "code",
  "sector",
  "borderline",
  "version"
)

use_data(nace_classification, overwrite = TRUE)

naics_classification_raw <- readr::read_csv(
  file.path("data-raw", "naics-2-6-digit_2022_Codes.csv"),
  col_names = c("code", "description"),
  col_types = "_cc__",
  skip = 2
)

naics_classification <- dplyr::mutate(
  naics_classification_raw,
  sector = dplyr::case_when(
    grepl("^3361", code) ~ "automotive",
    grepl("^4811", code) ~ "aviation",
    grepl("^481211", code) ~ "aviation",
    grepl("^3273", code) ~ "cement",
    grepl("^2121", code) ~ "coal",
    code == "213113" ~ "coal",
    grepl("^211", code) ~ "oil and gas",
    code %in% c("213111", "213112") ~ "oil and gas",
    grepl("^22111", code) ~ "power",
    code == "2211" ~ "power",
    grepl("^483", code) ~ "shipping",
    grepl("^3311", code) ~ "steel",
    code %in% c("331512", "331513") ~ "steel",
    TRUE ~ "not in scope"
  ),
  borderline = dplyr::case_when(
    code == "3361" ~ TRUE,
    grepl("^33612", code) ~ TRUE,
    code %in% c("4811", "481112") ~ TRUE,
    grepl("^32732", code) ~ TRUE,
    grepl("^32733", code) ~ TRUE,
    grepl("^32739", code) ~ TRUE,
    code == "3273" ~ TRUE,
   grepl("^21311", code) ~ TRUE,
    code == "2211" ~ TRUE,
    code %in% c("331512", "331513") ~ TRUE,
    TRUE ~ FALSE
  ),
)

naics_classification <- dplyr::mutate(naics_classification, version = "2022")

naics_classification <- dplyr::select(
  naics_classification,
  "description",
  "code",
  "sector",
  "borderline",
  "version"
)

usethis::use_data(naics_classification, overwrite = TRUE)

sic_classification_raw <- read_bridge(
  file.path("data-raw", "sic_classification.csv")
)

sic_classification <- dplyr::select(
  sic_classification_raw,
  "description",
  "code",
  "sector",
  "borderline"
)

usethis::use_data(sic_classification, overwrite = TRUE)

gics_classification_raw <- read_bridge(
  file.path("data-raw", "gics_classification.csv")
)

gics_classification <- dplyr::select(
  gics_classification_raw,
  "description",
  "code",
  "sector",
  "borderline"
)

usethis::use_data(gics_classification, overwrite = TRUE)

psic_classification_raw <- read_bridge(
  file.path("data-raw", "psic_classification.csv")
)

psic_classification <- dplyr::select(
  psic_classification_raw,
  description = "original_code",
  "code",
  "sector",
  "borderline"
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
    grepl("^C2431", code) ~ "steel", # borderline
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

isic_classification <- dplyr::select(
  isic_classification,
  original_code = "ISIC Rev 5 Code",
  description = "ISIC Rev 5 Title",
  "code",
  "sector",
  "borderline",
  "revision"
)

usethis::use_data(isic_classification, overwrite = TRUE)
