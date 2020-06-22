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
  count_duplicates <- function(data) {sum(duplicated(data))}

  out <- aggregate(isos ~ .,
    data = region_isos,
    FUN = count_duplicates
  )

  num_duplicates <- sum(out$isos)

  expect_equal(num_duplicates, 0L)
})
