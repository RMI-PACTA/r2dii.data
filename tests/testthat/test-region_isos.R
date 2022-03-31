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

test_that("outputs expected regions for weo_2020 (#253).", {
  expected_regions <- c(
    "advanced economies",
    "africa",
    "asia pacific",
    "caspian",
    "central and south america",
    "china",
    "developing asia",
    "eurasia",
    "europe",
    "european union",
    "latin america",
    "middle east",
    "north africa",
    "north america",
    "oecd",
    "opec",
    "other african countries and territories",
    "other asia pacific countries and territories",
    "other central and south american countries and territories",
    "southeast asia",
    "sub saharan africa",
    "global",
    "developing economies",
    "iea",
    "non oecd",
    "non opec",
    "brazil",
    "india",
    "japan",
    "russia",
    "south africa",
    "united states"
  )

  region_isos_weo_2020 <- region_isos[region_isos$source == "weo_2020", ]

  expect_equal(
    sort(unique(region_isos_weo_2020$region)),
    sort(expected_regions)
  )
})

test_that("outputs expected regions for isf_2020 (#253).", {
  expected_regions <- c(
    "oecd north america",
    "oecd europe",
    "global",
    "latin america",
    "india",
    "china",
    "africa",
    "middle east",
    "eurasia/eastern europe",
    "non oecd asia",
    "oecd pacific"
  )

  region_isos_isf_2020 <- region_isos[region_isos$source == "isf_2020", ]

  expect_equal(
    sort(unique(region_isos_isf_2020$region)),
    sort(expected_regions)
  )
})


test_that("outputs expected regions and countries for weo_2020 and weo_2019 (#271).", {
  expected_1country_region  <- tibble::tribble(
    ~region,          ~isos,  ~source,
    "brazil",         "br",   "weo_2019",
    "india",          "in",   "weo_2019",
    "japan",          "jp",   "weo_2019",
    "russia",         "ru",   "weo_2019",
    "south africa",   "za",   "weo_2019",
    "united states",  "us",   "weo_2019",
    "brazil",         "br",   "weo_2020",
    "india",          "in",   "weo_2020",
    "japan",          "jp",   "weo_2020",
    "russia",         "ru",   "weo_2020",
    "south africa",   "za",   "weo_2020",
    "united states",  "us",   "weo_2020"
  )
  
  region_isos_1country <- region_isos[
        (region_isos$source == "weo_2020" |
        region_isos$source == "weo_2019") &
        (region_isos$region == "brazil"|
        region_isos$region == "india"|
        region_isos$region == "japan"|
        region_isos$region == "russia"|
        region_isos$region == "south africa"|
        region_isos$region ==  "united states"),]
  
  expect_equal(
    region_isos_1country,
    expected_1country_region
  )
})
