test_that("hasn't changed", {
  expect_known_value(
    ald_demo, "ref-ald_demo",
    update = FALSE
  )
})

test_that("outputs no column `is_ultimate_owner` (#22)", {
  column_is_gone <- !any(grepl("is_ultimate_owner", names(ald_demo)))
  expect_true(column_is_gone)
})

test_that("outputs no column `is_ultimate_listed_owner` (#22)", {
  column_is_gone <- !any(grepl("is_ultimate_listed_owner", names(ald_demo)))
  expect_true(column_is_gone)
})
