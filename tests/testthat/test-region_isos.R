test_that("hasn't changed", {
  expect_known_value(
    region_isos, "ref-region_isos",
    update = FALSE
  )
})

test_that("is no different compared to reference", {
  expect_no_differences(
    region_isos, test_path("ref-region_isos")
  )
})
