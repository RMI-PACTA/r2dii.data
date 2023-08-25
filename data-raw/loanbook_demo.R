library(dplyr)
library(r2dii.data)
library(rlang)
library(tidyr)

# parameters
n_companies <- 20
total_exposure_lbk <- 100000000
total_credit_limit_lbk <- 500000000
currency_lbk <- "USD"

# define parameters for sampling----

# styler: off
sector_shares <- tibble::tribble(
  ~sector,    ~share,
  "aviation",   0.02,
  "automotive",  0.2,
  "cement",     0.02,
  "coal",       0.03,
  "hdv",           0,
  "oil and gas", 0.1,
  "power",       0.6,
  "shipping",      0,
  "steel",      0.03
)
# styler: on

# abcd_demo must be sourced first, as the loanbook is created based on this data
abcd <- r2dii.data::abcd_demo

# replace potential NA values with 0 in production
abcd_no_na <- abcd %>%
  dplyr::mutate(
    production = if_else(is.na(production), 0, production)
  )

# sample companies based on parameters----
# seed varies with number of companies and values of sector shares for some randomness
seed_i <- round(n_companies + sd(sector_shares$share) * 100)
set.seed(seed_i)

dist_abcd_sector <- abcd %>%
  dplyr::filter(.data$is_ultimate_owner) %>%
  dplyr::distinct(
    .data$company_id,
    .data$name_company,
    .data$sector
  )

n_companies_sector <- sector_shares %>%
  dplyr::mutate(n = round(.env$n_companies * .data$share, 0)) %>%
  dplyr::select(-"share")

sectors_to_sample <- sector_shares %>%
  dplyr::filter(.data$share > 0) %>%
  dplyr::distinct(.data$sector) %>%
  dplyr::pull()

sample_sectors <- NULL

for (i in sectors_to_sample) {
  n_companies_sector_i <- n_companies_sector %>%
    dplyr::filter(.data$sector == i) %>%
    dplyr::distinct(.data$n) %>%
    dplyr::pull()

  sample_sector_i <- dist_abcd_sector %>%
    dplyr::filter(.data$sector == i) %>%
    dplyr::slice_sample(n = n_companies_sector_i)

  sample_sectors <- sample_sectors %>%
    dplyr::bind_rows(sample_sector_i)
}

# set up basic loan book structure with sampled companies----
abcd_sample <- abcd %>%
  dplyr::inner_join(
    sample_sectors,
    by = c("company_id", "name_company", "sector")
  )

sample_sector_codes <- r2dii.data::nace_classification %>%
  dplyr::filter(.data$borderline == FALSE) %>%
  dplyr::group_by(.data$sector) %>%
  dplyr::slice_max(.data$code_level, n = 1) %>%
  dplyr::slice_head(n = 1) %>%
  dplyr::ungroup() %>%
  dplyr::select("sector", "code") %>%
  dplyr::mutate(
    sector_classification_system = "NACE",
    sector_classification_input_type = "Code"
  )

abcd_sample_sector_codes <- abcd_sample %>%
  dplyr::inner_join(
    sample_sector_codes,
    by = "sector"
  )

loanbook_sample_prep <- abcd_sample_sector_codes %>%
  dplyr::distinct(
    .data$company_id,
    .data$name_company,
    .data$lei,
    .data$sector_classification_system,
    .data$sector_classification_input_type,
    .data$code
  )

# TODO: how to handle group_id?
loanbook_sample <- tibble::tibble(
  id_direct_loantaker = paste0("C", loanbook_sample_prep$company_id),
  name_direct_loantaker = loanbook_sample_prep$name_company,
  id_intermediate_parent_1 = NA_character_,
  name_intermediate_parent_1 = NA_character_,
  id_ultimate_parent = paste0("UP", loanbook_sample_prep$company_id),
  name_ultimate_parent = loanbook_sample_prep$name_company,
  loan_size_outstanding = NA_real_,
  loan_size_outstanding_currency = .env$currency_lbk,
  loan_size_credit_limit = NA_real_,
  loan_size_credit_limit_currency = .env$currency_lbk,
  sector_classification_system = loanbook_sample_prep$sector_classification_system,
  sector_classification_input_type = loanbook_sample_prep$sector_classification_input_type,
  sector_classification_direct_loantaker = as.numeric(loanbook_sample_prep$code),
  fi_type = "Loan",
  flag_project_finance_loan = "No",
  name_project = NA_character_,
  lei_direct_loantaker = loanbook_sample_prep$lei,
  isin_direct_loantaker = NA_character_
) %>%
  tibble::rowid_to_column() %>%
  dplyr::mutate(id_loan = paste0("L", .data$rowid)) %>%
  dplyr::select(-"rowid")

# add randomly sampled loan size----
loanbook_demo <- loanbook_sample %>%
  dplyr::mutate(
    random_beta = stats::rbeta(n = nrow(loanbook_sample), shape1 = 1, shape2 = 3),
    share_exposure = .data$random_beta / sum(.data$random_beta, na.rm = TRUE)
  ) %>%
  dplyr::mutate(
    loan_size_outstanding = round(.data$share_exposure * .env$total_exposure_lbk, 0),
    loan_size_credit_limit = round(.data$share_exposure * .env$total_credit_limit_lbk, 0)
  ) %>%
  dplyr::select(-dplyr::all_of(c("random_beta", "share_exposure")))

usethis::use_data(loanbook_demo, overwrite = TRUE)
