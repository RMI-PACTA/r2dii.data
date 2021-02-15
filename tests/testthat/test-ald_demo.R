test_that("hasn't changed", {
  # FIXME: Fails on windows
  # expect_snapshot_value(ceiling_dbl(ald_demo), style = "json2")
  local_edition(2)
  expect_known_value(ald_demo, "ref-ald_demo")
})

test_that("ald_demo has column `id_company`", {
  expect_true(hasName(ald_demo, "id_company"))
})

test_that("ald_demo$id_company is of type character, as promised", {
  expect_type(ald_demo$id_company, "character")
})
