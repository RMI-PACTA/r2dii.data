test_that("hasn't changed", {
  on_windows <- identical(.Platform$OS.type, "windows")
  skip_if(on_windows)

  r_version <- paste0(
    R.version$major,
    ".",
    R.version$minor
  )
  r_version > "3.6.0"
  # ald_demo is now generated using random sampling.
  # random sampling seems to have changed in R after version 3.6.0
  # see ?RNGkind
  skip_if(r_version < "3.6.0")

  expect_snapshot_value(ceiling_dbl(ald_demo), style = "json2")
})

test_that("ald_demo has column `id_company`", {
  expect_true(hasName(ald_demo, "id_company"))
})

test_that("ald_demo$id_company is of type character, as promised", {
  expect_type(ald_demo$id_company, "character")
})

test_that("ald_demo$id_company is unique to `name_company` and `sector`", {
  out <- ald_demo[c("id_company", "name_company", "sector")]
  out <- unique(out)
  out <- out$id_company[duplicated(out$id_company)]

  expect_length(out, 0L)
})
