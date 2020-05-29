test_that("hasn't changed", {
  expect_known_value(
    ald_demo, "ref-ald_demo",
    update = FALSE
  )
})

test_that("is not different compared to reference", {
  reference <- readRDS(test_path("ref-ald_demo"))
  expect_identical(ald_demo, reference)
})
