test_that("hasn't changed", {
  expect_snapshot_value(data_dictionary, style = "json2")
})

test_that("has the expected names", {
  expect_named(
    data_dictionary,
    c("dataset", "column", "typeof", "definition")
  )
})

test_that("defines the expected objects", {
  datasets <- unique(data_dictionary$dataset)
  expected_datasets <- exported_data("r2dii.data")
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

test_that("Some datasets use tonne or tonnes, but not ton nor tons", {
  library(r2dii.data)
  datasets <- r2dii.data:::enlist_datasets("r2dii.data")

  # Helpers
  length_columns_contain <- function(data, pattern) {
    out <- lapply(data, column_contains, pattern = pattern)
    length(discard_empty(out))
  }
  column_contains <- function(data, pattern) {
    out <- lapply(data, function(.x) any(grepl(pattern = pattern, .x)))
    names(keep_true(out))
  }
  discard_empty <- function(x) {
    empty <- unlist(lapply(x, function(x) length(x) == 0))
    x[is.na(x) | !empty]
  }
  keep_true <- function(x) {
    true <- unlist(x)
    x[!is.na(x) & true]
  }

  # Some datasets have values that contain " tonnes "
  expect_true(length_columns_contain(datasets, pattern = " tonne ") > 0)
  # Some datasets have values that start with "tonnes "
  expect_true(length_columns_contain(datasets, pattern = "^tonnes ") > 0)

  # No dataset has values that contain " ton "
  expect_false(length_columns_contain(datasets, pattern = " ton ") > 0)
  # No dataset has values that start with "ton "
  expect_false(length_columns_contain(datasets, pattern = "^ton ") > 0)
})

test_that("documents the actual type of the column `code` (#185)", {
  standardize <- function(data) {
    data <- data[order(data$dataset), ]
    rownames(data) <- NULL
    class(data) <- "data.frame"
    data
  }

  documented <- r2dii.data::data_dictionary
  documented <- documented[documented$column == "code", c("dataset", "typeof")]

  classification_data <- enlist_datasets("r2dii.data", "classification")
  types <- unlist(lapply(classification_data, function(x) typeof(x[["code"]])))
  expected <- data.frame(
    dataset = names(types),
    typeof = unname(types),
    stringsAsFactors = FALSE
  )

  expect_equal(standardize(documented), standardize(expected))
})
