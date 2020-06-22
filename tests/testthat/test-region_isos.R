library(dplyr)

test_that("hasn't changed", {
  expect_known_value(
    region_isos, "ref-region_isos",
    update = FALSE
  )
})

test_that("is not different compared to reference", {
  reference <- readRDS(test_path("ref-region_isos"))
  expect_identical(region_isos, reference)
})

test_that("isos are not duplicated per region, scenario", {
  out <- region_isos %>%
    group_by(region, source) %>%
    mutate(not_duplicated = !duplicated(.data$isos)) %>%
    summarize(not_duplicated = all(not_duplicated))

  expect_true(all(out$not_duplicated))

})
