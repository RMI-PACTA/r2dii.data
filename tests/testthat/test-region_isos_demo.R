test_that("hasn't changed", {
  expect_known_value(
    region_isos_demo, "ref-region_isos_demo",
    update = FALSE
  )
})

test_that("is not different compared to reference", {
  reference <- readRDS(test_path("ref-region_isos_demo"))
  expect_identical(region_isos_demo, reference)
})
