test_that("hasn't changed", {
  ald_scenario_demo <-rbind(
    head(ald_scenario_demo, 250),
    tail(ald_scenario_demo, 250)
  )

  expect_known_value(
    ald_scenario_demo, "ref-ald_scenario_demo",
    update = FALSE
  )

  expect_no_differences(ald_scenario_demo, test_path("ref-ald_scenario_demo"))
})
