test_that("has no codes preceded by a 0", {
  first_code_digit <- substr(psic_classification$code, 1, 1)

  expect_false(0 %in% first_code_digit)
})

test_that("values of `sector` are lowercase not uppercase", {
  sectors <- sort(unique(psic_classification$sector))
  expect_equal(sectors, tolower(sectors))
})
