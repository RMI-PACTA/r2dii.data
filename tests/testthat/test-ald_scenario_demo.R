test_that("hasn't changed", {
  expect_known_value(
    ald_scenario_demo, "ref-ald_scenario_demo",
    update = FALSE
  )
})

test_that("hasn't changed", {
  expect_known_output(
    ald_scenario_demo, "ref-ald_scenario_demo-output",
    print = TRUE,
    update = FALSE
  )
})
