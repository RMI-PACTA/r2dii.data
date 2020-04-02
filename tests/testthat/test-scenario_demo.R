test_that("hasn't changed", {
  expect_known_value("scenario_demo_2020", "ref-scenario_demo_2020")
  expect_known_output(
    "scenario_demo_2020", "ref-scenario_demo_2020-output.txt"
  )
})
