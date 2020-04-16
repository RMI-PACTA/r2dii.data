test_that("hasn't changed", {
  # FIXME: When stable, use instead expect_known_value()
  expect_known_output(
    head(as.data.frame(ald_scenario_demo), 20),
    "ref-ald_scenario_demo-output",
    print = TRUE,
    update = T
  )
})

