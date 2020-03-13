test_that("hasn't change", {
  expect_known_value(
    sector_classifications, "ref-sector_classifications",
    update = FALSE
  )
  expect_known_output(
    sector_classifications, "ref-sector_classifications-output",
    update = FALSE,
    print = TRUE
  )
})

test_that("has an entry in data_dictionary", {
  dd <- data_dictionary()
  expect_true(nrow(dd[dd$dataset == "sector_classifications", ]) > 0)
})
