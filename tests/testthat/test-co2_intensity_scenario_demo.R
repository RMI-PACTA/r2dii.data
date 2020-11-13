test_that("hasn't change", {
  value <- round_dbl(co2_intensity_scenario_demo, 5L)
  expect_snapshot_value(value, style = "json2")
})
