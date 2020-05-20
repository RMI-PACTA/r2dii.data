test_that("hasn't changed", {
  expect_known_value(
    ald_scenario_demo, "ref-ald_scenario_demo",
    update = FALSE
  )
})
