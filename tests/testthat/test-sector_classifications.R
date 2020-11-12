test_that("hasn't change", {
  expect_snapshot_value(sector_classifications, style = "json2")
})

test_that("has an entry in data_dictionary", {
  dd <- data_dictionary
  expect_true(nrow(dd[dd$dataset == "sector_classifications", ]) > 0)
})
