test_that("hasn't changed", {
  expect_snapshot_value(scenario_demo_2020, style = "serialize")
})
