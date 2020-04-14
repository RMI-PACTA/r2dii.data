remove_spec <- function(data) {
  # https://bit.ly/avoid-cant-combine-spec-tbl-df
  withr::with_namespace("readr", {
    data <- data[]
  })

  check_no_spec(data)
  data
}

check_no_spec <- function(data) {
  stopifnot(!inherits(data, "spec_tbl_df"))
  stopifnot(is.null(attributes(data)$spec))
  invisible(data)
}
