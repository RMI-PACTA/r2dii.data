test_that("hasn't change", {
  expect_snapshot_value(green_or_brown, style = "json2")
})
