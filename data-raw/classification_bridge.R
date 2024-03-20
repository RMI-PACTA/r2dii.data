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
    grepl("^3362", code) ~ "automotive",
    grepl("^3363", code) ~ "automotive",
    grepl("^4811", code) ~ "aviation",
    grepl("^4812", code) ~ "aviation",
    grepl("^3273", code) ~ "cement",
    grepl("^2121", code) ~ "coal",
    code == "213113" ~ "coal",
    grepl("^211", code) ~ "oil and gas",
    code %in% c("213111", "213112") ~ "oil and gas",
    grepl("^2211", code) ~ "power",
    grepl("^483", code) ~ "shipping",
    grepl("^3311", code) ~ "steel",
    grepl("^3312", code) ~ "steel",
    code %in% c("331512", "331513") ~ "steel",
    TRUE ~ "not in scope"
  ),
  borderline = dplyr::case_when(
    code %in% c("336", "3361") ~ TRUE,
    grepl("^33612", code) ~ TRUE,
    grepl("^3362", code) ~ TRUE,
    grepl("^3363", code) ~ TRUE,
    code %in% c("4811", "48111", "481112") ~ TRUE,
    code %in% c("4812", "48121", "481212", "481219") ~ TRUE,
    code == "3273" ~ TRUE,
    grepl("^32732", code) ~ TRUE,
    grepl("^32733", code) ~ TRUE,
    grepl("^32739", code) ~ TRUE,
    code %in% c("213111", "213112") ~ TRUE,
    code == "213113" ~ TRUE,
    code == "2211" ~ TRUE,
    grepl("^22112", code) ~ TRUE,
    grepl("^3312", code) ~ TRUE,
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

sic_classification_raw <- readr::read_csv(
  "https://raw.githubusercontent.com/saintsjd/sic4-list/master/sic-codes.csv",
  col_types = "ccccc"
  )

# freeze the data in this package in-case the above link ever gets removed
# readr::write_csv(sic_classification_raw, "data-raw/sic_classification.csv")

sic_classification <- dplyr::mutate(
  sic_classification_raw,
  sector = dplyr::case_when(
    grepl("^5012", SIC) ~ "automotive",
    grepl("^451", SIC) ~ "aviation",
    grepl("^452", SIC) ~ "aviation",
    grepl("^324", SIC) ~ "cement",
    grepl("^122", SIC) ~ "coal",
    grepl("^124", SIC) ~ "coal",
    grepl("^13", SIC) ~ "oil and gas",
    grepl("^4911", SIC) ~ "power",
    SIC %in% c("3312", "3315", "3316", "3317", "3324", "3325", "3462") ~ "steel",
    TRUE ~ "not in scope"
  ),
  borderline = dplyr::case_when(
    grepl("^452", SIC) ~ TRUE,
    grepl("^124", SIC) ~ TRUE,
    SIC %in% c("1321", "1381", "1382", "1389") ~ TRUE,
    SIC %in% c("3313", "3315", "3316", "3317") ~ TRUE,
    TRUE ~ FALSE
  ),
)

sic_classification <- dplyr::mutate(
  sic_classification,
  version = "1987"
)

sic_classification <- dplyr::select(
  sic_classification,
  description = "Description",
  code = "SIC",
  "sector",
  "borderline",
  "version"
)

usethis::use_data(sic_classification, overwrite = TRUE)

gics_classification_raw <- readr::read_csv(
  file.path("data-raw", "GICS Map 2023.csv"),
  skip = 4,
  col_names = c(
    "sector_code",
    "sector_description",
    "industry_group_code",
    "industry_group_description",
    "industry_main_code",
    "industry_main_description",
    "sub_industry_code",
    "sub_industry_description"
  ),
  col_types = "cccccccc",
  na = c("", "\U000000A0", "NA")
)

gics_classification <- zoo::na.locf(
  zoo::zoo(gics_classification_raw),
  na.rm = FALSE
  )

gics_classification <- tibble::as_tibble(gics_classification)

gics_subset <- function(data, industry) {
  data |>
    dplyr::select(
      starts_with(industry)
    ) |>
    dplyr::distinct() |>
    dplyr::rename(
      code = glue::glue(industry, "_code"),
      description = glue::glue(industry, "_description")
    ) |>
    dplyr::mutate(
      industry_level = industry
    )
}

gics_classification <- dplyr::bind_rows(
  gics_subset(gics_classification, "sector"),
  gics_subset(gics_classification, "industry_group"),
  gics_subset(gics_classification, "industry_main"),
  gics_subset(gics_classification, "sub_industry")
)

gics_classification <- dplyr::mutate(
  gics_classification,
  industry_level = dplyr::if_else(
    industry_level == "industry_main",
    "industry",
    industry_level
  )
)

gics_classification <- dplyr::mutate(
  gics_classification,
  sector = dplyr::case_when(
    grepl("^2510", code) ~ "automotive",
    code == "20106010" ~ "automotive",
    grepl("^20301", code) ~ "aviation",
    grepl("^20302", code) ~ "aviation",
    grepl("^15102", code) ~ "cement",
    grepl("^1010205", code) ~ "coal",
    grepl("^10102", code) ~ "oil and gas",
    grepl("^551010", code) ~ "power",
    grepl("^551030", code) ~ "power",
    grepl("^551050", code) ~ "power",
    grepl("^20303", code) ~ "shipping",
    grepl("^1510405", code) ~ "steel",
    TRUE ~ "not in scope"
  ),
  borderline = dplyr::case_when(
    code == "20106010" ~TRUE,
    code == "2510" ~ TRUE,
    grepl("^25101", code) ~ TRUE,
    grepl("^20301", code) ~ TRUE,
    grepl("^15102", code) ~ TRUE,
    grepl("^1010203", code) ~ TRUE,
    grepl("^1010204", code) ~ TRUE,
    code == "15104050" ~ TRUE,
    grepl("^551030", code) ~ TRUE,
    grepl("^551050", code) ~ TRUE,
    TRUE ~ FALSE
  ),
)

gics_classification <- dplyr::filter(
  gics_classification,
  # sometimes there are two similar descriptions,
  # take the one that is more precise.
  nchar(description) == max(nchar(description)),
  .by = -description
)

gics_classification <- dplyr::mutate(
  gics_classification,
  version = "2023"
)

gics_classification <- dplyr::select(
  gics_classification,
  "description",
  "code",
  "sector",
  "borderline",
  "version"
)

gics_classification <- dplyr::arrange(gics_classification, code)

usethis::use_data(gics_classification, overwrite = TRUE)

psic_classification_raw <- read_bridge(
  file.path("data-raw", "psic_classification.csv")
)

psic_classification <- dplyr::mutate(
  psic_classification_raw,
  version = "2019"
)

psic_classification <- dplyr::select(
  psic_classification,
  description = "original_code",
  "code",
  "sector",
  "borderline",
  "version"
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
