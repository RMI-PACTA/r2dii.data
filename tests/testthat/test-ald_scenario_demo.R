test_that("hasn't changed", {
  x <- rbind(head(ald_scenario_demo, 250), tail(ald_scenario_demo, 250))
  expect_known_value(
    x, "ref-ald_scenario_demo",
    update = FALSE
  )
})
