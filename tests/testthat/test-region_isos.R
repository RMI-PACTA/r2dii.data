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
    "nze_2021",
    "geco_2020",
    "geco_2021",
    "geco_2022",
    "geco_2023",
    "etp_2020",
    "weo_2021",
    "weo_2022",
    "weo_2023",
    "isf_2023"
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


test_that("outputs expected '1-country-regions' for weo_2019 (#271).", {
  country_regions_weo_2019 <- c(
    "brazil",
    "india",
    "japan",
    "russia",
    "south africa",
    "united states"
  )

  expect_equal(
    setdiff(
      country_regions_weo_2019,
      region_isos[region_isos$source == "weo_2019", ][["region"]]
    ),
    character(0)
  )
})
