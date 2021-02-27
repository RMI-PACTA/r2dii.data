library(withr)
library(tibble)
library(rlang)

read_csv_ <- function(file) {
  out <- readr::read_csv(file)

  # https://bit.ly/avoid-cant-combine-spec-tbl-df
  withr::with_namespace("readr", {
    out <- out[]
  })

  tibble::remove_rownames(out)
}

read_bridge <- function(file) {
  out <- read_csv_(file)
  # Avoid #222 from accidentally happening again
  out$sector <- tolower(out$sector)
  out
}

check_no_spec <- function(data) {
  stopifnot(!inherits(data, "spec_tbl_df"))
  stopifnot(is.null(attributes(data)$spec))
  invisible(data)
}

co2_per <- function(x) {
  paste("tonnes of CO2 per", x)
}

new_emission_factor_unit <- function() {
  # styler: off
  tibble::tribble(
    ~sector,     ~ald_emission_factor_unit,
    "automotive",      co2_per("km per car produced"),
    "oil and gas",     co2_per("GJ"),
    "coal",            co2_per("tonne of coal"),
    "steel",           co2_per("tonne of steel"),
    "cement",          co2_per("tonne of cement"),
    "aviation",        co2_per("passenger per km travelled"),
    "power",           co2_per("per hour per MW")

  )
  # styler: on
}

#' Check if a named object contains expected names
#'
#' Based on fgeo.tool::check_crucial_names()
#'
#' @param x A named object.
#' @param expected_names String; expected names of `x`.
#'
#' @return Invisible `x`, or an error with informative message.
#'
#' @examples
#' x <- c(a = 1)
#' check_crucial_names(x, "a")
#' try(check_crucial_names(x, "bad"))
#' @noRd
check_crucial_names <- function(x, expected_names) {
  stopifnot(rlang::is_named(x))
  stopifnot(is.character(expected_names))

  ok <- all(unique(expected_names) %in% names(x))
  if (!ok) {
    abort_missing_names(sort(setdiff(expected_names, names(x))))
  }

  invisible(x)
}

abort_missing_names <- function(missing_names) {
  rlang::abort(
    "missing_names",
    message = glue(
      "Must have missing names:
      {paste0('`', missing_names, '`', collapse = ', ')}"
    )
  )
}
