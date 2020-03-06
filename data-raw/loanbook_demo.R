# Source: https://github.com/2DegreesInvesting/r2dii.dataraw/pull/4

#' Helper: If column `X1` exists, remove it
#'
#' The column `X1` may exist and contain needless rownames. It's likely the
#' result of the default argument `row.names = FALSE` to `read.table()`.
#'
#' @examples
#' remove_rownames_column(data.frame(X1 = 1, x = 2))
#' @noRd
remove_rownames_column <- function(data) {
  if (!rlang::has_name(data, "X1")) {
    return(data)
  }

  data$X1 <- NULL
  data
}

path <- here::here("data-raw/loanbook.csv")
loanbook_demo <- remove_rownames_column(readr::read_csv(path))

usethis::use_data(loanbook_demo, overwrite = TRUE)
