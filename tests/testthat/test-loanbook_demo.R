library(dplyr)

test_that("loanbook_demo hasn't changed", {
  expect_known_value(
    loanbook_demo, "ref-loanbook_demo",
    update = FALSE
  )
})
