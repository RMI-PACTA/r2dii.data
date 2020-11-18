test_that("hasn't changed", {
  expect_snapshot_value(green_or_brown, style = "json2")
})
