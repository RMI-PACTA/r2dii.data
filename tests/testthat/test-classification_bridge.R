test_that("all classification datasets have minimum expected names", {
  all_data <- enlist_datasets("r2dii.data", pattern = "")
  classification_data <- all_data[grepl("_classification", names(all_data))]
  crucial <- c("code", "sector", "borderline")

  actual <- purrr::map_lgl(classification_data, ~ all(crucial %in% names(.x)))
  expect <- c(
    isic_classification = TRUE,
    nace_classification = TRUE,
    naics_classification = TRUE
  )
  expect_equal(actual, expect)
})
