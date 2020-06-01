test_that("hasn't changed", {
  expect_known_value(
    loanbook_demo, "ref-loanbook_demo",
    update = FALSE
  )
})

test_that("is not different compared to reference", {
  reference <- readRDS(test_path("ref-loanbook_demo"))
  expect_identical(loanbook_demo, reference)
})

test_that("has all ascii characters", {
  x <- r2dii.data::loanbook_demo$name_direct_loantaker
  is_ascii <- stringr::str_detect(stringi::stri_enc_mark(x), "ASCII")
  expect_true(all(is_ascii))
})
