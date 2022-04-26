test_that("throws the expected warning", {
  expect_warning(ald_demo, "superseded")
})

test_that("is identical to abcd_demo", {
  superseded <- suppressWarnings(ald_demo)
  expect_equal(superseded, abcd_demo)
})
