test_that("no data inherits spec_tbl_df", {
  library(r2dii.data)
  has_spec <- suppressWarnings(
    vapply(
      enlist_datasets("r2dii.data"),
      function(.x) inherits(.x, "spec_tbl_df"),
      logical(1)
    )
  )

  expect_false(any(has_spec))
})

test_that("no data is grouped", {
  library(r2dii.data)
  is_grouped <- vapply(
    enlist_datasets("r2dii.data"),
    function(.x) inherits(.x, "grouped_df"),
    logical(1)
  )

  expect_false(any(is_grouped))
})
