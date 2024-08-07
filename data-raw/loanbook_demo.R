library(dplyr)
library(usethis)
devtools::load_all()

source(file.path("data-raw", "utils.R"))

# Source: https://github.com/2DegreesInvesting/r2dii.dataraw/pull/4
# added a coal and a steel company to cover all sectors in demo loan book (#315)
path <- file.path("data-raw", "loanbook_demo.csv")
loanbook_demo <- readr::read_csv(
  path,
  col_types = readr::cols_only(
    id_loan = "c",
    id_direct_loantaker = "c",
    name_direct_loantaker = "c",
    id_ultimate_parent = "c",
    name_ultimate_parent = "c",
    loan_size_outstanding = "d",
    loan_size_outstanding_currency = "c",
    loan_size_credit_limit = "d",
    loan_size_credit_limit_currency = "c",
    sector_classification_system = "c",
    sector_classification_direct_loantaker = "c",
    lei_direct_loantaker = "c",
    isin_direct_loantaker = "c"
  )
)

loanbook_demo$loan_size_outstanding <- as.double(
  loanbook_demo$loan_size_outstanding
)

loanbook_demo <- loanbook_demo %>%
  mutate(
    name_direct_loantaker = case_when(
      name_direct_loantaker == "Holcim Hüttenzement" ~ "Holcim Huttenzement",
      TRUE ~ name_direct_loantaker
    ),
    name_ultimate_parent = case_when(
      name_ultimate_parent == "Sa Tudela Veguín" ~ "Sa Tudela Veguin",
      name_ultimate_parent == "Chongyang Hui’An Cement" ~ "Chongyang Hui'An Cement",
      TRUE ~ name_ultimate_parent
    )
  )

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
  original_code = stringr::str_replace(.data[["NACE21_CODE"]], "\\.", "")
)

# this gets the `original_code` back to the `loanbook_demo` dataset
loanbook_demo <- mutate(
  loanbook_demo,
  sector_classification_direct_loantaker = as.character(sector_classification_direct_loantaker)
)

loanbook_demo <- left_join(
  loanbook_demo,
  select(nace_classification, original_code, code),
  by = c("sector_classification_direct_loantaker" = "original_code")
)

loanbook_demo <- mutate(
  loanbook_demo,
  sector_classification_direct_loantaker = code,
  original_code = NULL,
  code = NULL
  )

# add ABCD LEIs to loanbook_demo
abcd_leis <- distinct(abcd_demo, name_company, lei)
loanbook_demo <- left_join(
  loanbook_demo,
  abcd_leis,
  by = c("name_ultimate_parent" = "name_company")
)

loanbook_demo <- dplyr::mutate(
  loanbook_demo,
  lei_direct_loantaker = lei,
  lei = NULL
  )

loanbook_demo <- dplyr::filter(
  loanbook_demo,
  !is.na(sector_classification_direct_loantaker)
)

usethis::use_data(loanbook_demo, overwrite = TRUE)
