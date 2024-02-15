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
  out$code <- as.character(out$code)
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
    "power",           co2_per("per hour per MW"),
    "hdv",           co2_per("km per vehicle produced"),

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

convert_superseded_nace_code <- function(data,
                                         col_from,
                                         col_to) {
  data <- mutate(
    data,
    prepend_value = case_when(
      .data[[col_from]] %in% LETTERS ~ "",
      trunc(as.numeric(.data[[col_from]])) %in% seq(1, 3) ~ "A",
      trunc(as.numeric(.data[[col_from]])) %in% seq(5, 9) ~ "B",
      trunc(as.numeric(.data[[col_from]])) %in% seq(10, 33) ~ "C",
      trunc(as.numeric(.data[[col_from]])) == 35 ~ "D",
      trunc(as.numeric(.data[[col_from]])) %in% seq(36, 39) ~ "E",
      trunc(as.numeric(.data[[col_from]])) %in% seq(41, 43) ~ "F",
      trunc(as.numeric(.data[[col_from]])) %in% seq(45, 47) ~ "G",
      trunc(as.numeric(.data[[col_from]])) %in% seq(49, 53) ~ "H",
      trunc(as.numeric(.data[[col_from]])) %in% seq(55, 56) ~ "I",
      trunc(as.numeric(.data[[col_from]])) %in% seq(58, 63) ~ "J",
      trunc(as.numeric(.data[[col_from]])) %in% seq(64, 66) ~ "K",
      trunc(as.numeric(.data[[col_from]])) == 68 ~ "L",
      trunc(as.numeric(.data[[col_from]])) %in% seq(69, 75) ~ "M",
      trunc(as.numeric(.data[[col_from]])) %in% seq(77, 82) ~ "N",
      trunc(as.numeric(.data[[col_from]])) == 84 ~ "O",
      trunc(as.numeric(.data[[col_from]])) == 85 ~ "P",
      trunc(as.numeric(.data[[col_from]])) %in% seq(86, 88) ~ "Q",
      trunc(as.numeric(.data[[col_from]])) %in% seq(90, 93) ~ "R",
      trunc(as.numeric(.data[[col_from]])) %in% seq(94, 96) ~ "S",
      trunc(as.numeric(.data[[col_from]])) %in% seq(97, 98) ~ "T",
      trunc(as.numeric(.data[[col_from]])) == 99 ~ "U",
      TRUE ~ "Z" #debug value, see unit tests)
    )
  )

  data <- mutate(
    data,
    {{col_to}} := paste0(prepend_value, .data[[col_from]]),
    prepend_value = NULL
  )
}
