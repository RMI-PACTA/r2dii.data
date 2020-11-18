test_that("hasn't changed", {
  expect_snapshot_value(region_isos_demo, style = "json2")
})
