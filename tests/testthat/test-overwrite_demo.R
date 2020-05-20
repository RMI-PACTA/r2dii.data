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

  expect_no_differences(
    overwrite_demo,
    test_path("ref-overwrite_demo")
  )
})
