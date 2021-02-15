test_that("hasn't changed", {
  expect_snapshot_value(ceiling_dbl(ald_demo), style = "json2")
})

test_that("ald_demo has column `id_company`", {
  expect_true(hasName(ald_demo, "id_company"))
})
