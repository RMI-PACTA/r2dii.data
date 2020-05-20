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

co2_per <- function(x) {
  paste("tons of CO2 per", x)
}

new_emission_factor_unit <- function() {
  # styler: off
  tibble::tribble(
    ~sector,     ~ald_emission_factor_unit,
    "automotive",      co2_per("km per car produced"),
    "oil and gas",     co2_per("GJ"),
    "coal",            co2_per("ton of coal"),
    "steel",           co2_per("ton of steel"),
    "cement",          co2_per("ton of cement"),
    "aviation",        co2_per("passenger per km travelled"),
    "power",           co2_per("per hour per MW")

  )
  # styler: on
}
