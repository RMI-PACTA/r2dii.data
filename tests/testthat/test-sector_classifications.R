test_that("hasn't changed", {
  expect_snapshot_value(sector_classifications, style = "json2")
})

test_that("has an entry in data_dictionary", {
  dd <- data_dictionary
  expect_true(nrow(dd[dd$dataset == "sector_classifications", ]) > 0)
})

test_that("nace automotive sales are borderline", {

  automotive_sales <- c(
    451,
    4511,
    4519
  )

  nace_sc <- sector_classifications[sector_classifications$code_system == "NACE", ]

  automotive_sales <- nace_sc[nace_sc$code %in% automotive_sales, ]

  expect_true(all(automotive_sales$borderline))

})
