test_that("hasn't change", {
  expect_known_value(
    sector_classifications, "ref-sector_classifications",
    update = FALSE
  )
})

test_that("has an entry in data_dictionary", {
  dd <- data_dictionary()
  expect_true(nrow(dd[dd$dataset == "sector_classifications", ]) > 0)
})
