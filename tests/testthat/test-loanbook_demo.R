test_that("hasn't changed", {
  expect_known_value(
    loanbook_demo, "ref-loanbook_demo",
    update = FALSE
  )

  expect_no_differences(
    loanbook_demo,
    test_path("ref-loanbook_demo")
  )
})
