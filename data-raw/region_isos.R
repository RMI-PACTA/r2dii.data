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

pick_type <- function(data, .type) {
  data %>%
    filter(.data$type == .type) %>%
    select(-.data$type)
}

join_countries <- function(data, countries) {
  data %>%
    select(region, .data$value) %>%
    left_join(countries, by = c("value" = "region")) %>%
    select(-.data$value) %>%
    rename(value = .data$value.y)
}

prepare_regions <- function(data, countries, regions = NULL) {
  regions <- regions %||% as.character(na.omit(unique(data$region)))

  data %>%
    pick_type("region") %>%
    filter(.data$region %in% regions) %>%
    join_countries(countries)
}

# some regions are cyclically defined using other regions in the raw data
# we need to expand these and join them back in
bind_countries <- function(data_countries, data_region, regions = NULL) {
  data_countries %>%
    rbind(prepare_regions(data_region, data_countries, regions)) %>%
    arrange(.data$region)
}

unique_countries <- function(data) {
  unique(select(data, .data$value))
}

global_data <- function(data, source) {
  data %>%
    unique_countries() %>%
    mutate(region = "global", source = source)
}

warn_if_is_missing_country_isos <- function(fix) {
  if (nrow(fix) > 0L) {
    warning(
      "`country_iso` is missing in ", nrow(fix), " rows:
      Likely not all countries will match or have isos, e.g. smaller polynesian
      islands may be unmatched. Country definitions are not standardized and
      change. Match only until you are happy.",
      call. = FALSE
    )
  }

  invisible(fix)
}

prepare_isos <- function(data) {
  data %>%
    left_join(r2dii.data::iso_codes, by = c("value" = "country")) %>%
    filter(!is.na(.data$country_iso)) %>%
    rename(isos = .data$country_iso) %>%
    select(.data$region, .data$isos, .data$source)
}



# Source: raw_regions_weo_2019.csv was transcribed from page 780 of the 2019
# World Energy Outlook
weo_year <- "weo_2019"
region_data <- read_regions(regions_path(weo_year))

bound1 <- region_data %>%
  pick_type("country_name") %>%
  bind_countries(region_data, regions = NULL)

advanced_economies <- bound1 %>% filter(.data$region == "advanced economies")

developing_economies <- bound1 %>%
  unique_countries() %>%
  filter(!(.data$value %in% advanced_economies$value)) %>%
  mutate(region = "developing economies", source = weo_year)

oecd <- filter(bound1, .data$region == "oecd")

not_in_iea <- c(
  "chile",
  "iceland",
  "israel",
  "latvia",
  "lithuania",
  "slovenia"
)

iea <- oecd %>%
  filter(!(.data$value %in% not_in_iea)) %>%
  mutate(region = "iea")

non_oecd <- bound1 %>%
  unique_countries() %>%
  filter(!(.data$value %in% oecd$value)) %>%
  mutate(region = "non oecd", source = weo_year)

opec <- region_data %>% filter(.data$region == "opec")

non_opec <- bound1 %>%
  unique_countries() %>%
  filter(!(.data$value %in% opec$value)) %>%
  mutate(region = "non opec", source = weo_year)

# check how many countries don't match their isos
bound1 %>%
  rbind(developing_economies, iea, non_oecd, non_opec) %>%
  left_join(r2dii.data::iso_codes, by = c("value" = "country")) %>%
  filter(is.na(.data$country_iso)) %>%
  warn_if_is_missing_country_isos()

region_isos_weo_2019 <- bound1 %>%
  rbind(
    global_data(., weo_year),
    developing_economies,
    iea,
    non_oecd,
    non_opec
  ) %>%
  prepare_isos()



######################## SAME but for ETP 2017
# Source:
# * raw_regions_etp_2017.csv was transcribed from page 780 of the 2017 Energy
# Technology Perspectives

weo_year <- "etp_2017"

region_data <- read_regions(regions_path(weo_year))

# some regions are cyclically defined using other regions in the raw data
# we need to expand these and join them back in
bound3 <- region_data %>%
  pick_type("country_name") %>%
  bind_countries(region_data, "oecd asia oceania") %>%
  bind_countries(region_data, "oecd")


# check how many countries dont match their isos
bound3 %>%
  left_join(r2dii.data::iso_codes, by = c("value" = "country")) %>%
  filter(is.na(.data$country_iso)) %>%
  warn_if_is_missing_country_isos()

region_isos_etp_2017 <- bound3 %>%
  rbind(global_data(., weo_year)) %>%
  prepare_isos()

region_isos <- rbind(region_isos_weo_2019, region_isos_etp_2017)

usethis::use_data(region_isos, overwrite = TRUE)
