test_that("hasn't changed", {
  expect_known_value(
    scenario_demo_2020, "ref-co2_intensity_scenario_demo",
    update = TRUE
  )
})
