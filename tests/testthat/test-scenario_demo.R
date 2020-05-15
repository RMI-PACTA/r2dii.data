test_that("hasn't changed", {
  expect_known_value(
    scenario_demo_2020, "ref-scenario_demo_2020",
    update = FALSE
  )
})
