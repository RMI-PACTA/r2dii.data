test_that("hasn't changed", {
  expect_known_value(
    "emissions_intensity_scenario_demo", "ref-emissions_intensity_scenario_demo",
    update = FALSE
  )
})
