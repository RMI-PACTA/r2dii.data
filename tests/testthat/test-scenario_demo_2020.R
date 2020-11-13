test_that("hasn't changed", {
  value <- round_dbl(scenario_demo_2020)
  expect_snapshot_value(value, style = "json2")
})
