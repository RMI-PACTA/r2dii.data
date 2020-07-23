test_that("green_or_brown hasn't changed", {
  expect_known_value(
    green_or_brown, "ref-green_or_brown",
    update = FALSE
  )
})

test_that("is not different compared to reference", {
  reference <- readRDS(test_path("ref-green_or_brown"))
  expect_identical(green_or_brown, reference)
})
