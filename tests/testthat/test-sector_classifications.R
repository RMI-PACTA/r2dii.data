test_that("hasn't change", {
  expect_snapshot_value(sector_classifications, style = "json2")
})

test_that("is not different compared to reference", {
  reference <- readRDS(test_path("ref-sector_classifications"))
  expect_identical(sector_classifications, reference)
})

test_that("has an entry in data_dictionary", {
  dd <- data_dictionary
  expect_true(nrow(dd[dd$dataset == "sector_classifications", ]) > 0)
})
