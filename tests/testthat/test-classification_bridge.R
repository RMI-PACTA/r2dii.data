test_that("all classification data has minimim expected names", {
  ends_with_classification <- grep(
    pattern = "_classification$",
    x = exported_data("r2dii.data"),
    value = TRUE
  )

  classification_list <- ends_with_classification %>%
    purrr::map(~ get(.x, envir = as.environment("package:r2dii.data"))) %>%
    purrr::set_names(ends_with_classification)

  # https://github.com/2DegreesInvesting/r2dii.match/issues/7
  crucial <- c("code", "sector", "borderline")
  expect_error(
    purrr::walk(
      classification_list, ~ r2dii.utils::check_crucial_names(.x, crucial)
    ),
    NA
  )
})
