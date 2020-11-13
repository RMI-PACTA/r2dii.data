test_that("hasn't change", {
  expect_snapshot_value(co2_intensity_scenario_demo, style = "serialize")
})
