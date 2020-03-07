test_that("overwrite_demo has the expected names", {
  expect_named(
    overwrite_demo,
    c("level", "id_2dii", "name", "sector", "source")
  )
})

test_that("overwrite_demo hasn't changed", {
  expect_known_value(
    overwrite_demo, "ref-overwrite_demo",
    update = FALSE
  )
})
