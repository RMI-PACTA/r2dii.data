test_that("all classification datasets have minimum expected names", {
  classification_data <- list(
    isic_classification = isic_classification,
    nace_classification = nace_classification,
    naics_classification = naics_classification
  )

  actual <- vapply(
    classification_data,
    function(.x) all(c("code", "sector", "borderline") %in% names(.x)),
    FUN.VALUE = logical(1)
  )
  expect <- c(
    isic_classification = TRUE,
    nace_classification = TRUE,
    naics_classification = TRUE
  )
  expect_equal(actual, expect)
})

test_that("nace and naics are not identical (#85)", {
  expect_false(identical(nace_classification, naics_classification))
})

test_that("In classification datasets, `code` is of type 'character' (#185)", {
  datasets <- enlist_datasets("r2dii.data", "classification")
  types <- unlist(lapply(datasets, function(x) typeof(x[["code"]])))
  expect_equal(unique(types), "character")
})

