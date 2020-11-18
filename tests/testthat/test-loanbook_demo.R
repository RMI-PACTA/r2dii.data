test_that("hasn't changed", {
  expect_snapshot_value(loanbook_demo, style = "json2")
})
