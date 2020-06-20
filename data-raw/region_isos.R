library(tibble)
library(dplyr)
library(usethis)
library(rlang)

regions_path <- function(x) {
  file.path("data-raw", paste0("region_isos_", x, ".csv"))
}

read_regions <- function(path) {
  utils::read.csv(
    path,
    colClasses = "character",
    na.strings = c("", "NA"),
    stringsAsFactors = FALSE
  ) %>%
    tibble::as_tibble()
}

subset_country_name <- function(data) {
  data %>%
  dplyr::filter(type == "country_name") %>%
  dplyr::select(-type)
}

subset_leftover_regions <- function(data) {
  data %>%
  dplyr::filter(type == "region") %>%
  dplyr::select(-type)
}

join_countries <- function(data, countries) {
  data %>%
    dplyr::select(region, value) %>%
    dplyr::left_join(countries, by = c("value" = "region")) %>%
    dplyr::select(-value) %>%
    dplyr::rename(value = value.y)
}

prepare_regions <- function(data, countries, regions = NULL) {
  regions <- regions %||% as.character(na.omit(unique(data$region)))

  data %>%
    subset_leftover_regions() %>%
    dplyr::filter(region %in% regions) %>%
    join_countries(countries)
}

# some regions are cyclically defined using other regions in the raw data
# we need to expand these and join them back in
bind_countries <- function(countries, region_data, regions) {
  rbind(countries, prepare_regions(region_data, countries, regions = regions)) %>%
    dplyr::arrange(region)
}

unique_countries <- function(data) {
  unique(dplyr::select(data, value))
}

global_data <- function(data, source) {
  data %>%
    unique_countries() %>%
    dplyr::mutate(region = "global", source = source)
}

warn_if_country_iso_is_missing <- function(fix) {
  if (nrow(fix) > 0L) {
    warning(
      "`country_iso` is missing in ", nrow(fix), " rows:
      Likely not all countries will match or have isos, e.g. smaller polynesian
      islands may be unmatched. Country definitions are not standardized and
      change. Match only until you are happy.",
      call. = FALSE
    )
  }
}



# Source: raw_regions_weo_2019.csv was transcribed from page 780 of the 2019
# World Energy Outlook
weo_year <- "weo_2019"
region_data <- read_regions(regions_path(weo_year))

bound1 <- bind_countries(
  subset_country_name(region_data), region_data, regions = NULL
)

advanced_economies <- bound1 %>%
  dplyr::filter(region == "advanced economies")

developing_economies <- bound1 %>%
  unique_countries() %>%
  dplyr::filter(!(value %in% advanced_economies$value)) %>%
  dplyr::mutate(region = "developing economies", source = weo_year)

oecd <- dplyr::filter(bound1, region == "oecd")

not_in_iea <- c(
  "chile",
  "iceland",
  "israel",
  "latvia",
  "lithuania",
  "slovenia"
)

iea <- oecd %>%
  dplyr::filter(!(value %in% not_in_iea)) %>%
  dplyr::mutate(region = "iea")

non_oecd <- bound1 %>%
  unique_countries() %>%
  dplyr::filter(!(value %in% oecd$value)) %>%
  dplyr::mutate(region = "non oecd", source = weo_year)

opec <- dplyr::filter(bound1, region == "opec")

non_opec <- bound1 %>%
  unique_countries() %>%
  dplyr::filter(!(value %in% opec$value)) %>%
  dplyr::mutate(region = "non opec", source = weo_year)

# check how many countries don't match their isos
fix <- bound1 %>%
  rbind(developing_economies, iea, non_oecd, non_opec) %>%
  dplyr::left_join(r2dii.data::iso_codes, by = c("value" = "country")) %>%
  dplyr::filter(is.na(country_iso))

warn_if_country_iso_is_missing(fix)


prepare_isos <- function(data) {
  data %>%
    dplyr::left_join(r2dii.data::iso_codes, by = c("value" = "country")) %>%
    dplyr::filter(!is.na(country_iso)) %>%
    dplyr::rename(isos = country_iso) %>%
    dplyr::select(region, isos, source)
}
region_isos_weo_2019 <- bound1 %>%
  rbind(
    global_data(., weo_year),
    developing_economies,
    iea,
    non_oecd,
    non_opec
  ) %>%
  prepare_isos()
  # dplyr::left_join(r2dii.data::iso_codes, by = c("value" = "country")) %>%
  # dplyr::filter(!is.na(country_iso)) %>%
  # dplyr::rename(isos = country_iso) %>%
  # dplyr::select(region, isos, source)














######################## SAME but for ETP 2017
# Source:
# * raw_regions_etp_2017.csv was transcribed from page 780 of the 2017 Energy
# Technology Perspectives

weo_year <- "etp_2017"

region_data <-  read_regions(regions_path(weo_year))

# some regions are cyclically defined using other regions in the raw data
# we need to expand these and join them back in
bound2 <- bind_countries(
  subset_country_name(region_data), region_data, "oecd asia oceania"
)

bound3 <- bind_countries(
  bound2, region_data, "oecd"
)


# check how many countries dont match their isos
fix <- bound3 %>%
  dplyr::left_join(r2dii.data::iso_codes, by = c("value" = "country")) %>%
  dplyr::filter(is.na(country_iso))

warn_if_country_iso_is_missing(fix)

region_isos_etp_2017 <- bound3 %>%
  rbind(global_data(., weo_year)) %>%
  dplyr::left_join(r2dii.data::iso_codes, by = c("value" = "country")) %>%
  dplyr::filter(!is.na(country_iso)) %>%
  dplyr::rename(isos = country_iso) %>%
  dplyr::select(region, isos, source)

region_isos <- rbind(region_isos_weo_2019, region_isos_etp_2017)

usethis::use_data(region_isos, overwrite = TRUE)
