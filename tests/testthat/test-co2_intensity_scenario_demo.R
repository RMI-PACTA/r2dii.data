test_that("hasn't changed", {
  expect_known_value(
    co2_intensity_scenario_demo, "ref-co2_intensity_scenario_demo",
    update = FALSE
  )
})

test_that("is not different compared to reference", {
  reference <- readRDS(test_path("ref-co2_intensity_scenario_demo"))
  expect_identical(co2_intensity_scenario_demo, reference)
})
