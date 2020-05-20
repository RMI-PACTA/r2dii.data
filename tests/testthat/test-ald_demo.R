test_that("hasn't changed", {
  expect_known_value(
    ald_demo, "ref-ald_demo",
    update = FALSE
  )

})

test_that("is no different to reference", {
  skip_on_cran()
  expect_no_differences(ald_demo, "ref-ald_demo")
})

