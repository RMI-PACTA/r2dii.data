test_that("hasn't changed", {
  expect_snapshot_value(round_dbl(ald_demo), style = "json2")
})
