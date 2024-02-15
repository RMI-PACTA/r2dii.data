test_that("hasn't changed", {
  expect_snapshot_value(loanbook_demo, style = "json2")
})

test_that("loanbook_demo has at least one valid sector classification (#336)", {
  #base R left_join
  out <- merge(
    loanbook_demo,
    sector_classifications,
    by.x = c(
      "sector_classification_system",
      "sector_classification_direct_loantaker"
    ),
    by.y = c(
      "code_system",
      "code"
    ),
    all.x = TRUE
  )

  number_of_sector_matches <- nrow(
    out[!is.na(out[["sector"]]), ]
  )

  expect_true(number_of_sector_matches > 0)

})
