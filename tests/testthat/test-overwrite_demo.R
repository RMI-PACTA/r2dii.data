test_that("hasn't change", {
  expect_snapshot_value(overwrite_demo, style = "json2")
})

test_that("has the expected names", {
  expect_named(
    overwrite_demo,
    c("level", "id_2dii", "name", "sector", "source")
  )
})
