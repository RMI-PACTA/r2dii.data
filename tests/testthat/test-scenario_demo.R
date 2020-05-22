test_that("hasn't changed", {
  expect_known_value(
    scenario_demo_2020, "ref-scenario_demo_2020",
    update = FALSE
  )
})

test_that("is not different compared to reference", {
  expect_no_differences(
    scenario_demo_2020, test_path("ref-scenario_demo_2020")
  )
})
