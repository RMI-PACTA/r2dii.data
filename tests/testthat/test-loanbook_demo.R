test_that("hasn't changed", {
  expect_known_value(
    loanbook_demo, "ref-loanbook_demo",
    update = FALSE
  )
})

test_that("is not different compared to reference", {
  reference <- readRDS(test_path("ref-loanbook_demo"))
  expect_identical(loanbook_demo, reference)
})
