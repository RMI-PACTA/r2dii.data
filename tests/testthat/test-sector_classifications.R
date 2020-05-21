test_that("hasn't change", {
  expect_known_value(
    sector_classifications, "ref-sector_classifications",
    update = FALSE
  )
})

test_that("is no different compared to reference", {
  expect_no_differences(
    sector_classifications, test_path("ref-sector_classifications")
  )
})

test_that("has an entry in data_dictionary", {
  dd <- data_dictionary
  expect_true(nrow(dd[dd$dataset == "sector_classifications", ]) > 0)
})
