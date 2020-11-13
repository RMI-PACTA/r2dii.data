test_that("hasn't change", {
  expect_snapshot_value(loanbook_demo, style = "json2")
})
