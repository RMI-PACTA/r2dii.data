test_that("region_isos hasn't changed", {
  expect_known_value(
    region_isos, "ref-region_isos",
    update = FALSE
  )
})
