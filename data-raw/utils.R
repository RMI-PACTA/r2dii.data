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

prepend_letter_nace_code <- function(data,
                                     col_from,
                                     col_to) {
  data <- dplyr::mutate(
    data,
    prepend_value = dplyr::case_when(
      .data[[col_from]] %in% LETTERS ~ "",
      substr(.data[[col_from]], 0, 2) %in% paste0(0, seq(1, 3)) ~ "A",
      substr(.data[[col_from]], 0, 2) %in% paste0(0, seq(5, 9)) ~ "B",
      substr(.data[[col_from]], 0, 2) %in% as.character(seq(10, 33)) ~ "C",
      substr(.data[[col_from]], 0, 2) %in% as.character(35) ~ "D",
      substr(.data[[col_from]], 0, 2) %in% as.character(seq(36, 39)) ~ "E",
      substr(.data[[col_from]], 0, 2) %in% as.character(seq(41, 43)) ~ "F",
      substr(.data[[col_from]], 0, 2) %in% as.character(seq(46, 47)) ~ "G",
      substr(.data[[col_from]], 0, 2) %in% as.character(seq(49, 53)) ~ "H",
      substr(.data[[col_from]], 0, 2) %in% as.character(seq(49, 53)) ~ "H",
      substr(.data[[col_from]], 0, 2) %in% as.character(seq(55, 56)) ~ "I",
      substr(.data[[col_from]], 0, 2) %in% as.character(seq(58, 60)) ~ "J",
      substr(.data[[col_from]], 0, 2) %in% as.character(seq(61, 63)) ~ "K",
      substr(.data[[col_from]], 0, 2) %in% as.character(seq(64, 66)) ~ "L",
      substr(.data[[col_from]], 0, 2) %in% as.character(68) ~ "M",
      substr(.data[[col_from]], 0, 2) %in% as.character(seq(69, 75)) ~ "N",
      substr(.data[[col_from]], 0, 2) %in% as.character(seq(77, 82)) ~ "O",
      substr(.data[[col_from]], 0, 2) %in% as.character(84) ~ "P",
      substr(.data[[col_from]], 0, 2) %in% as.character(85) ~ "Q",
      substr(.data[[col_from]], 0, 2) %in% as.character(seq(86, 88)) ~ "R",
      substr(.data[[col_from]], 0, 2) %in% as.character(seq(90, 93)) ~ "S",
      substr(.data[[col_from]], 0, 2) %in% as.character(seq(94, 96)) ~ "T",
      substr(.data[[col_from]], 0, 2) %in% as.character(seq(97, 98)) ~ "U",
      substr(.data[[col_from]], 0, 2) %in% as.character(99) ~ "V",
      TRUE ~ "Z" # debug value, see unit tests
    )
  )

  data <- dplyr::mutate(
    data,
    {{ col_to }} := paste0(prepend_value, .data[[col_from]]),
    prepend_value = NULL
  )
}

prepend_letter_isic_code <- function(data,
                                     col_from,
                                     col_to) {
  data <- dplyr::mutate(
    data,
    prepend_value = dplyr::case_when(
      .data[[col_from]] %in% LETTERS ~ "",
      substr(.data[[col_from]], 0, 2) %in% paste0(0, seq(1, 3)) ~ "A",
      substr(.data[[col_from]], 0, 2) %in% paste0(0, seq(5, 9)) ~ "B",
      substr(.data[[col_from]], 0, 2) %in% as.character(seq(10, 33)) ~ "C",
      substr(.data[[col_from]], 0, 2) %in% as.character(35) ~ "D",
      substr(.data[[col_from]], 0, 2) %in% as.character(seq(36, 39)) ~ "E",
      substr(.data[[col_from]], 0, 2) %in% as.character(seq(41, 43)) ~ "F",
      substr(.data[[col_from]], 0, 2) %in% as.character(seq(46, 47)) ~ "G",
      substr(.data[[col_from]], 0, 2) %in% as.character(seq(49, 53)) ~ "H",
      substr(.data[[col_from]], 0, 2) %in% as.character(seq(49, 53)) ~ "H",
      substr(.data[[col_from]], 0, 2) %in% as.character(seq(55, 56)) ~ "I",
      substr(.data[[col_from]], 0, 2) %in% as.character(seq(58, 60)) ~ "J",
      substr(.data[[col_from]], 0, 2) %in% as.character(seq(61, 63)) ~ "K",
      substr(.data[[col_from]], 0, 2) %in% as.character(seq(64, 66)) ~ "L",
      substr(.data[[col_from]], 0, 2) %in% as.character(68) ~ "M",
      substr(.data[[col_from]], 0, 2) %in% as.character(seq(69, 75)) ~ "N",
      substr(.data[[col_from]], 0, 2) %in% as.character(seq(77, 82)) ~ "O",
      substr(.data[[col_from]], 0, 2) %in% as.character(84) ~ "P",
      substr(.data[[col_from]], 0, 2) %in% as.character(85) ~ "Q",
      substr(.data[[col_from]], 0, 2) %in% as.character(seq(86, 88)) ~ "R",
      substr(.data[[col_from]], 0, 2) %in% as.character(seq(90, 93)) ~ "S",
      substr(.data[[col_from]], 0, 2) %in% as.character(seq(94, 96)) ~ "T",
      substr(.data[[col_from]], 0, 2) %in% as.character(seq(97, 98)) ~ "U",
      substr(.data[[col_from]], 0, 2) %in% as.character(99) ~ "V",
      TRUE ~ "Z" # debug value, see unit tests)
    )
  )

  data <- dplyr::mutate(
    data,
    {{ col_to }} := paste0(prepend_value, .data[[col_from]]),
    prepend_value = NULL
  )
}
