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



# Source: raw_regions_weo_2019.csv was transcribed from page 780 of the 2019
# World Energy Outlook
weo_year <- "weo_2019"

region_data <- read_regions(regions_path(weo_year))
countries <- subset_country_name(region_data)

out_only_countries <- bind_countries(countries, region_data, regions = NULL)

all_countries <- out_only_countries %>%
  dplyr::select(value) %>%
  unique()

global <- all_countries %>%
  dplyr::mutate(region = "global", source = weo_year)

advanced_economies <- out_only_countries %>%
  dplyr::filter(region == "advanced economies")

developing_economies <- all_countries %>%
  dplyr::filter(!(value %in% advanced_economies$value)) %>%
  dplyr::mutate(region = "developing economies", source = weo_year)

oecd <- dplyr::filter(out_only_countries, region == "oecd")

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

non_oecd <- all_countries %>%
  dplyr::filter(!(value %in% oecd$value)) %>%
  dplyr::mutate(region = "non oecd", source = weo_year)

opec <- dplyr::filter(out_only_countries, region == "opec")

non_opec <- all_countries %>%
  dplyr::filter(!(value %in% opec$value)) %>%
  dplyr::mutate(region = "non opec", source = weo_year)

# check how many countries don't match their isos
fix <- out_only_countries %>%
  rbind(developing_economies, iea, non_oecd, non_opec) %>%
  dplyr::left_join(r2dii.data::iso_codes, by = c("value" = "country")) %>%
  dplyr::filter(is.na(country_iso))

if (nrow(fix) > 0L) {
  warning(
    "`country_iso` is missing in ", nrow(fix), " rows:
    Likely not all countries will match or have isos, e.g. smaller polynesian
    islands may be unmatched. Country definitions are not standardized and
    change. Match only until you are happy.",
    call. = FALSE
  )
}

region_isos_weo_2019 <- out_only_countries %>%
  rbind(global, developing_economies, iea, non_oecd, non_opec) %>%
  dplyr::left_join(r2dii.data::iso_codes, by = c("value" = "country")) %>%
  dplyr::filter(!is.na(country_iso)) %>%
  dplyr::rename(isos = country_iso) %>%
  dplyr::select(region, isos, source)














######################## SAME but for ETP 2017
# Source:
# * raw_regions_etp_2017.csv was transcribed from page 780 of the 2017 Energy
# Technology Perspectives

weo_year <- "etp_2017"

region_data <-  read_regions(regions_path(weo_year))
countries <- subset_country_name(region_data)

# some regions are cyclically defined using other regions in the raw data
# we need to expand these and join them back in
countries2 <- bind_countries(countries, region_data, "oecd asia oceania")


region <- "oecd"
out_only_countries <- rbind(countries2, prepare_regions(region_data, countries2, region)) %>%
  dplyr::arrange(region)

all_countries <- out_only_countries %>%
  dplyr::select(value) %>%
  unique()

global <- all_countries %>%
  dplyr::mutate(region = "global", source = weo_year)

# check how many countries dont match their isos
fix <- out_only_countries %>%
  dplyr::left_join(r2dii.data::iso_codes, by = c("value" = "country")) %>%
  dplyr::filter(is.na(country_iso))

if (nrow(fix) > 0L) {
  warning(
    "`country_iso` is missing in ", nrow(fix), " rows:
    Likely not all countries will match or have isos, e.g. smaller polynesian
    islands may be unmatched. Country definitions are not standardized and
    change. Match only until you are happy.",
    call. = FALSE
  )
}

region_isos_etp_2017 <- out_only_countries %>%
  rbind(global) %>%
  dplyr::left_join(r2dii.data::iso_codes, by = c("value" = "country")) %>%
  dplyr::filter(!is.na(country_iso)) %>%
  dplyr::rename(isos = country_iso) %>%
  dplyr::select(region, isos, source)

region_isos <- rbind(region_isos_weo_2019, region_isos_etp_2017)

usethis::use_data(region_isos, overwrite = TRUE)
