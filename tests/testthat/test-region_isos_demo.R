test_that("hasn't changed", {
  expect_known_value(
    region_isos_demo, "ref-region_isos_demo",
    update = FALSE
  )
})

test_that("hasn't changed", {
  expect_known_output(
    region_isos_demo, "ref-region_isos_demo-output",
    print = TRUE,
    update = FALSE
  )
})
