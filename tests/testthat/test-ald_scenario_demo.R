test_that("hasn't changed", {
  small_ald_scenario_demo <-rbind(
    head(ald_scenario_demo, 250),
    tail(ald_scenario_demo, 250)
  )

  expect_known_value(
    small_ald_scenario_demo, "ref-ald_scenario_demo",
    update = FALSE
  )
})

test_that("is not different compared to reference", {
  small_ald_scenario_demo <-rbind(
    head(ald_scenario_demo, 250),
    tail(ald_scenario_demo, 250)
  )

  reference <- readRDS(test_path("ref-ald_scenario_demo"))
  expect_identical(small_ald_scenario_demo, reference)
})
