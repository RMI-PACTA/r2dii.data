test_that("hasn't changed", {
  set.seed(1)
  rows <- sample(1:nrow(ald_scenario_demo), 500L)
  expect_known_value(
    ald_scenario_demo[rows, ], "ref-ald_scenario_demo",
    update = FALSE
  )
})
