test_that("hasn't changed", {
  expect_known_value(
    data_dictionary, "ref-data_dictionary",
    update = FALSE
  )
})

test_that("is not different compared to reference", {
  reference <- readRDS(test_path("ref-data_dictionary"))
  expect_identical(data_dictionary, reference)
})

test_that("has the expected names", {
  expect_named(
    data_dictionary,
    c("dataset", "column", "typeof", "definition")
  )
})

test_that("defines the expected objects", {
  datasets <- unique(data_dictionary$dataset)

  expected_datasets <- c(
    "ald_demo",
    "co2_intensity_scenario_demo",
    "data_dictionary",
    "green_or_brown",
    "isic_classification",
    "iso_codes",
    "loanbook_demo",
    "nace_classification",
    "naics_classification",
    "overwrite_demo",
    "region_isos",
    "region_isos_demo",
    "sector_classifications",
    "scenario_demo_2020"
  )

  expect_equal(sort(datasets), sort(expected_datasets))
})

test_that("defines all its names", {
  dd <- data_dictionary
  dd_definitions <- dd[dd$dataset == "data_dictionary", , drop = FALSE]
  expect_equal(nrow(dd_definitions), 4L)

  dd_columns <- sort(dd_definitions$column)
  expect_equal(dd_columns, sort(names(data_dictionary)))
})

test_that("includes suffix _demo", {
  dd <- data_dictionary$dataset
  expect_true("ald_demo" %in% dd)
  expect_true("loanbook_demo" %in% dd)
})

test_that("outputs as many rows per `dataset` as columns in `dataset`", {
  # Data in data_dictionary
  dic <- data_dictionary
  defined1 <- dic[dic$dataset != "data_dictionary", c("dataset", "column")]
  defined2 <- table(defined1$dataset)

  # Data in data/
  datasets <- lapply(mget(names(defined2), inherits = TRUE), ncol)
  n_cols <- datasets[sort(names(datasets))]

  # Should have the same names
  expect_equal(names(defined2), names(n_cols))

  # Compare num cols of each dataset in data/ to num of rows in data_dictionary
  out <- data.frame(
    dataset = names(defined2),
    n = as.integer(unname(defined2)),
    n_col = as.integer(n_cols),
    stringsAsFactors = FALSE
  )
  out2 <- transform(out, is_equal = out$n == out$n_col)
  expect_true(all(out2$is_equal))
})
