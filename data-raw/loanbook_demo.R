# Source: https://github.com/2DegreesInvesting/r2dii.dataraw/pull/4

path <- here::here("data-raw/loanbook_demo.csv")
# The column `X1` may exist and contain needless rownames -- that's likely
# because the data was read with `read.table()` using `row.names = FALSE`
if (hasName(data, "X1")) stop("Must remove column `X1`")
loanbook_demo <- remove_rownames_column(readr::read_csv(path))

usethis::use_data(loanbook_demo, overwrite = TRUE)
