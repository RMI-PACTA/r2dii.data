test_that("iso_codes hasn't changed", {
  expect_known_value(
    iso_codes, "ref-iso_codes",
    update = FALSE
  )
})

test_that("is not different compared to reference", {
  expect_no_differences(
    iso_codes, test_path("ref-iso_codes")
  )
})
