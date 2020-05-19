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
    ~technology,     ~ald_emission_factor_unit,
    "hydrocap",      co2_per("hour per MW"),
    "renewablescap", co2_per("hour per MW"),
    "oil",           co2_per("GJ"),
    "gas",           co2_per("GJ"),
    "coal",          co2_per("tons of coal"),
    "electric",      co2_per("km per cars produced"),
    "hybrid",        co2_per("km per cars produced"),
    "ice",           co2_per("km per cars produced"),
    "coalcap",       co2_per("hour per MW"),
    "gascap",        co2_per("hour per MW"),
    "oilcap",        co2_per("hour per MW"),
    "nuclearcap",    co2_per("hour per MW"),
  )
  # styler: on
}

add_emission_factor_unit <- function(data, emission_factor_unit) {
  data %>%
    select(-.data$ald_emission_factor_unit) %>%
    left_join(emission_factor_unit, by = "technology")
}

add_emission_factor_unit2 <- function(data, emission_factor_unit) {
  data %>%
    left_join(emission_factor_unit, by = "technology")
}
