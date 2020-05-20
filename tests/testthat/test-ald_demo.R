test_that("hasn't changed", {
  expect_known_value(
    ald_demo, "ref-ald_demo",
    update = FALSE
  )

  expect_no_differences(
    ald_demo,
    test_path("ref-ald_demo")
  )
})
