test_that("hasn't changed", {
  expect_known_value(
    co2_intensity_scenario_demo, "ref-co2_intensity_scenario_demo",
    update = FALSE
  )
})

test_that("is not different compared to reference", {
  expect_no_differences(
    co2_intensity_scenario_demo, test_path("ref-co2_intensity_scenario_demo")
  )
})
