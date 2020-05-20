library(usethis)

source(file.path("data-raw", "utils.R"))

# Source: https://github.com/2DegreesInvesting/r2dii.dataraw/pull/4
path <- file.path("data-raw", "loanbook_demo.csv")
loanbook_demo <- read_csv_(path)

usethis::use_data(loanbook_demo, overwrite = TRUE)
