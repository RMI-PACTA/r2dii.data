test_that("outputs expected named tibble", {
  expect_is(sector_classification_df(), "tbl_df")

  expect_named(
    sector_classification_df(), c("sector", "borderline", "code", "code_system")
  )

  expect_known_output(
    sector_classification_df(), "ref-sector_classification_df",
    update = FALSE
  )
})
