test_that("hasn't changed", {
  expect_known_value(
    region_isos_demo, "ref-region_isos_demo",
    update = FALSE
  )
})

test_that("is not different compared to reference", {
  expect_no_differences(
    region_isos_demo, test_path("ref-region_isos_demo")
  )
})
