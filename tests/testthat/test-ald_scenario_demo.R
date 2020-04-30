test_that("hasn't changed", {
  expect_known_value(
    head(as.data.frame(ald_scenario_demo), 20),
    "ref-ald_scenario_demo",
    update = FALSE
  )
})
