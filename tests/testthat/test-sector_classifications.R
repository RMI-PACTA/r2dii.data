test_that("hasn't changed", {
  expect_snapshot_value(sector_classifications, style = "json2")
})

test_that("has an entry in data_dictionary", {
  dd <- data_dictionary
  expect_true(nrow(dd[dd$dataset == "sector_classifications", ]) > 0)
})

test_that("nace automotive sales are borderline", {
  automotive <- c(451, 4511, 4519)
  borderline <- subset(
    sector_classifications,
    subset = code_system == "NACE" & code %in% automotive,
    select = "borderline",
    drop = TRUE
  )

  expect_true(all(borderline))
})

test_that("psic_classification has no codes preceded by a 0", {
  first_code_digit <- substr(psic_classification$code, 1, 1)

  expect_false(0 %in% first_code_digit)
})
