test_that("has the expected names", {
  expect_named(
    overwrite_demo,
    c("level", "id_2dii", "name", "sector", "source")
  )
})

test_that("hasn't changed", {
  expect_known_value(
    overwrite_demo, "ref-overwrite_demo",
    update = FALSE
  )
})
