test_that("hasn't changed", {
  expect_snapshot_value(ceiling_dbl(ald_demo), style = "json2")
})

test_that("ald_demo has column `id_company`", {
  ald_demo_columns <- names(ald_demo)

  expect_true("id_company" %in% ald_demo_columns)
})
