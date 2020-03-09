test_that("data_dictionary defines the expected objects", {
  datasets <- data_dictionary() %>%
    dplyr::pull(dataset) %>%
    unique()

  expected_datasets <- c(
    "ald",
    "data_dictionary",
    "isic_classification",
    "iso_codes",
    "loanbook",
    "nace_classification",
    "naics_classification",
    "overwrite",
    "region_isos",
    "scenario"
  )

  expect_equal(sort(datasets), sort(expected_datasets))
})

test_that("data_dictionary hasn't changed", {
  # TODO: Remove once the object is complete (once #2 is merged)
  expect_known_output(
    as.data.frame(data_dictionary()), "ref-data_dictionary-output",
    update = TRUE,
    print = TRUE
  )
  expect_known_value(
    data_dictionary(), "ref-data_dictionary",
    update = TRUE
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

test_that("defines column original_code of dataset naics_classification", {
  dd <- data_dictionary()
  defined <- dd[dd$dataset == "naics_classification", ]$column
  expect_true(any(defined %in% "original_code"))
})
