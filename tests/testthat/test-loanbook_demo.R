test_that("hasn't changed", {
  expect_known_value(
    loanbook_demo, "ref-loanbook_demo",
    update = FALSE
  )
})

test_that("is no different compared to reference", {
  expect_no_differences(
    loanbook_demo,test_path("ref-loanbook_demo")
  )
})
