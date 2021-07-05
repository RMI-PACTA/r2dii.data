test_that("hasn't changed", {
  expect_snapshot_value(region_isos, style = "json2")
})

test_that("isos are not duplicated per region, scenario", {
  expect_false(any(duplicated(region_isos)))
})

test_that("outputs regions for expected scenario sources", {
  expected_sources <- c(
    "weo_2019",
    "etp_2017",
    "weo_2020",
    "isf_2020",
    "nze_2021"
  )

  expect_equal(
    sort(unique(region_isos$source)),
    sort(expected_sources)
  )
})
