test_that("data_dictionary defines the expected objects", {
  datasets <- data_dictionary() %>%
    dplyr::pull(dataset) %>%
    unique()

  expected_datasets <- c(
    "ald_demo",
    "data_dictionary",
    "isic_classification",
    "iso_codes",
    "loanbook_demo",
    "nace_classification",
    "naics_classification",
    "overwrite_demo",
    "region_isos",
    "scenario_demo"
  )

  expect_equal(sort(datasets), sort(expected_datasets))
})

test_that("data_dictionary hasn't changed", {
  expect_known_value(
    data_dictionary(), "ref-data_dictionary",
    update = FALSE
  )
})

test_that("data_dictionary has the expected names", {
  expect_named(
    data_dictionary(),
    c("dataset", "column", "typeof", "definition")
  )
})

test_that("data_dictionary defines all its names", {
  dd_definitions <- data_dictionary() %>%
    dplyr::filter(.data$dataset == "data_dictionary")

  expect_equal(nrow(dd_definitions), 4L)

  dd_columns <- sort(dd_definitions$column)
  expect_equal(dd_columns, sort(names(data_dictionary())))
})

test_that("includes suffix _demo", {
  dd <- data_dictionary()$dataset
  expect_true("ald_demo" %in% dd)
  expect_true("loanbook_demo" %in% dd)
})
