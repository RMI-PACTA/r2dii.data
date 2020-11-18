test_that("hasn't changed", {
  expect_snapshot_value(iso_codes, style = "json2")
})
