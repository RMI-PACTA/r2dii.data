test_that("hasn't changed", {
  expect_known_value(
    region_isos, "ref-region_isos",
    update = FALSE
  )
})

test_that("hasn't changed", {
  expect_known_output(
    region_isos, "ref-region_isos-output",
    print = TRUE,
    update = FALSE
  )
})
