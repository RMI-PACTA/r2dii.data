test_that("hasn't changed", {
  expect_known_value(
    scenario_demo_2020, "ref-scenario_demo_2020",
    update = FALSE
  )
})

test_that("is not different compared to reference", {
  reference <- readRDS(test_path("ref-scenario_demo_2020"))
  expect_identical(scenario_demo_2020, reference)
})
