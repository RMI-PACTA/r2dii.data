test_that("define() produces the expected output", {
  expected <- c(
    "* `isos` (character): Countries in region, defined by iso code.",
    "* `region` (character): Benchmark region name.",
    "* `source` (character): Source publication from which the regions are defined."
  )
  actual <- unclass(define("region_isos"))
  expect_equal(actual, expected)
})
