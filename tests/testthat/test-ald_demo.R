test_that("hasn't changed", {
  on_windows <- identical(.Platform$OS.type, "windows")
  skip_if(on_windows)
  expect_snapshot_value(ceiling_dbl(ald_demo), style = "json2")
})

test_that("ald_demo has column `id_company`", {
  expect_true(hasName(ald_demo, "id_company"))
})

test_that("ald_demo$id_company is of type character, as promised", {
  expect_type(ald_demo$id_company, "character")
})

test_that("ald_demo$id_company is unique to `name_company` and `sector`", {
  out <- ald_demo %>%
    dplyr::select(id_company, name_company, sector) %>%
    unique() %>%
    dplyr::filter(duplicated(id_company))

  expect_length(out$id_company, 0L)
})
