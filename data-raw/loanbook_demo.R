source(here::here("data-raw/utils.R"))

# Source: https://github.com/2DegreesInvesting/r2dii.dataraw/pull/4

path <- here::here("data-raw/loanbook_demo.csv")
loanbook_demo <- remove_spec(readr::read_csv(path))

usethis::use_data(loanbook_demo, overwrite = TRUE)
