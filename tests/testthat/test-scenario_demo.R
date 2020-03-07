test_that("scenario_demo hasn't changed", {
  expect_known_value(
    scenario_demo, "ref-scenario_demo",
    update = FALSE
  )
})
