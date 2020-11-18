test_that("hasn't changed", {
  expect_snapshot_value(region_isos, style = "json2")
})

test_that("isos are not duplicated per region, scenario", {
  expect_false(any(duplicated(region_isos)))
})
