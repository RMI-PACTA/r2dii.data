test_that("source_data_raw() sources .R files and only .R files", {
  data_raw <- file.path(tempdir(), "data-raw")
  if (!dir.exists(data_raw)) {
    dir.create(data_raw)
  }

  on.exit(unlink(data_raw, recursive = TRUE), add = TRUE)

  test_r <- file.path(data_raw, "test.R")
  writeLines("r_test <- 'should exist'", test_r)
  on.exit(unlink(test_r), add = TRUE)

  test_txt <- file.path(data_raw, "test.txt")
  writeLines("txt_test <- 'should not exist'", test_txt)
  on.exit(unlink(test_txt), add = TRUE)

  source_data_raw(data_raw)
  expect_true(exists("r_test"))
  expect_false(exists("txt_test"))
})

test_that("define() produces the expected output", {
  expected <- c(
    "* `isos` (character): Countries in region, defined by iso code.",
    "* `region` (character): Benchmark region name.",
    "* `source` (character): Source publication from which the regions are defined."
  )
  actual <- unclass(define("region_isos"))
  expect_equal(actual, expected)
})
