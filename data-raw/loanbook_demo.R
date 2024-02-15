library(dplyr)
library(usethis)

source(file.path("data-raw", "utils.R"))

# Source: https://github.com/2DegreesInvesting/r2dii.dataraw/pull/4
# added a coal and a steel company to cover all sectors in demo loan book (#315)
path <- file.path("data-raw", "loanbook_demo.csv")
loanbook_demo <- readr::read_csv(
  path,
  col_types = readr::cols(
    id_loan = "c",
    id_direct_loantaker = "c",
    name_direct_loantaker = "c",
    id_intermediate_parent_1 = "c",
    name_intermediate_parent_1 = "c",
    id_ultimate_parent = "c",
    name_ultimate_parent = "c",
    loan_size_outstanding = "d",
    loan_size_outstanding_currency = "c",
    loan_size_credit_limit = "d",
    loan_size_credit_limit_currency = "c",
    sector_classification_system = "c",
    sector_classification_input_type = "c",
    sector_classification_direct_loantaker = "d",
    fi_type = "c",
    flag_project_finance_loan = "c",
    name_project = "c",
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

loanbook_demo <- convert_superseded_nace_code(
  loanbook_demo,
  col_from = "sector_classification_direct_loantaker",
  col_to = "sector_classification_direct_loantaker"
)

usethis::use_data(loanbook_demo, overwrite = TRUE)
