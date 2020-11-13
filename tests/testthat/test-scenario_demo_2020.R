test_that("hasn't changed", {
  value <- round_dbl(scenario_demo_2020, 5L)
  expect_snapshot_value(value, style = "json2")
})
