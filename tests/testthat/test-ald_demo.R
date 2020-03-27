test_that("hasn't changed", {
  expect_known_value(
    ald_demo, "ref-ald_demo",
    update = FALSE
  )
  expect_known_output(
    tibble::as_tibble(ald_demo), "ref-ald_demo-output",
    print = TRUE,
    update = FALSE
  )
})

test_that("outputs no column `is_ultimate_owner` (#22)", {
  column_is_gone <- !any(grepl("is_ultimate_owner", names(ald_demo)))
  expect_true(column_is_gone)
})
