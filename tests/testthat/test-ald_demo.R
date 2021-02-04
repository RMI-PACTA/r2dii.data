test_that("hasn't changed", {
  expect_snapshot_value(round_dbl(ald_demo, 3L), style = "json2")
})
