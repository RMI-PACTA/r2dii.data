test_that("throws the expected warning", {
  on_r_cmd <- !identical(Sys.getenv("R_CMD"), "")
  skip_if(on_r_cmd)
  expect_warning(ald_demo, "superseded")
})

test_that("is identical to abcd_demo", {
  expect_equal(suppressWarnings(ald_demo), abcd_demo)
})
