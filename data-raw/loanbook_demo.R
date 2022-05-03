library(usethis)

source(file.path("data-raw", "utils.R"))

# Source: https://github.com/2DegreesInvesting/r2dii.dataraw/pull/4
path <- file.path("data-raw", "loanbook_demo.csv")
loanbook_demo <- read_csv_(path)

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

usethis::use_data(loanbook_demo, overwrite = TRUE)
