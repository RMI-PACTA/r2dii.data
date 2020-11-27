library(dplyr)
library(usethis)
library(rlang)

# Helpers -----------------------------------------------------------------

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
    select(.data$region, .data$value) %>%
    left_join(countries, by = c("value" = "region")) %>%
    select(-.data$value) %>%
    rename(value = .data$value.y)
}

prepare_regions <- function(data_region, data_countries, regions = NULL) {
  regions <- regions %||% as.character(na.omit(unique(data_region$region)))

  data_region %>%
    pick_type("region") %>%
    filter(.data$region %in% regions) %>%
    join_countries(data_countries)
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

warn_if_is_missing_country_isos <- function(data) {
  fix <- data %>%
    left_join(r2dii.data::iso_codes, by = c("value" = "country")) %>%
    filter(is.na(.data$country_iso))

  if (nrow(fix) > 0L) {
    warning(
      "`country_iso` is missing in ", nrow(fix), " rows:
      Likely not all countries will match or have isos, e.g. smaller polynesian
      islands may be unmatched. Country definitions are not standardized and
      change. Match only until you are happy.",
      call. = FALSE
    )
  }

  invisible(data)
}

prepare_isos <- function(data) {
  data %>%
    left_join(r2dii.data::iso_codes, by = c("value" = "country")) %>%
    filter(!is.na(.data$country_iso)) %>%
    rename(isos = .data$country_iso) %>%
    select(.data$region, .data$isos, .data$source)
}

exclude_values <- function(data, values, .region) {
  data %>%
    filter(!(.data$value %in% values)) %>%
    mutate(region = .region)
}

# Some isos are missing from the global regions definition. Here we read in the
# actual isos from a real ALD file, and buffer the potentially missing isos.
ald_path <- file.path("data-raw", paste0("ald_all_isos", ".csv"))
ald_isos <- read_regions(ald_path)

# Process raw_regions_weo_2019.csv ----------------------------------------

# Source: raw_regions_weo_2019.csv was transcribed from page 780 of the 2019
# World Energy Outlook
source_year <- "weo_2019"
region_data <- read_regions(regions_path(source_year))

bound1 <- region_data %>%
  pick_type("country_name") %>%
  bind_countries(region_data, regions = NULL)

advanced_economies <- bound1 %>%
  filter(.data$region == "advanced economies")

developing_economies <- bound1 %>%
  unique_countries() %>%
  filter(!(.data$value %in% advanced_economies$value)) %>%
  mutate(region = "developing economies", source = source_year)

oecd <- bound1 %>%
  filter(.data$region == "oecd")

not_in_iea <- c(
  "chile",
  "iceland",
  "israel",
  "latvia",
  "lithuania",
  "slovenia"
)

iea <- oecd %>%
  exclude_values(not_in_iea, .region = "iea")

non_oecd <- bound1 %>%
  unique_countries() %>%
  exclude_values(oecd$value, .region = "non oecd") %>%
  mutate(source = source_year)

opec <- region_data %>%
  filter(.data$region == "opec")

non_opec <- bound1 %>%
  unique_countries() %>%
  exclude_values(opec$value, .region = "non opec") %>%
  mutate(source = source_year)

bound1 %>%
  rbind(
    developing_economies,
    iea,
    non_oecd,
    non_opec
  ) %>%
  warn_if_is_missing_country_isos()

region_isos_weo_2019 <- bound1 %>%
  rbind(
    global_data(., source_year),
    developing_economies,
    iea,
    non_oecd,
    non_opec
  ) %>%
  prepare_isos() %>%
  bind_rows(mutate(ald_isos, source = "weo_2019")) %>%
  unique()

# Process raw_regions_etp_2017.csv ----------------------------------------

# Source: raw_regions_etp_2017.csv was transcribed from page 780 of the 2017
# Energy Technology Perspectives
source_year <- "etp_2017"
region_data <- read_regions(regions_path(source_year))

# some regions are cyclically defined using other regions in the raw data
# we need to expand these and join them back in
region_isos_etp_2017 <- region_data %>%
  pick_type("country_name") %>%
  bind_countries(region_data, "oecd asia oceania") %>%
  bind_countries(region_data, "oecd") %>%
  warn_if_is_missing_country_isos() %>%
  rbind(global_data(., source_year)) %>%
  prepare_isos() %>%
  bind_rows(mutate(ald_isos, source = "etp_2017")) %>%
  unique()

# Combine -----------------------------------------------------------------

region_isos <- rbind(
  region_isos_weo_2019,
  region_isos_etp_2017
) %>%
  group_by(region, source) %>%
  distinct(isos) %>%
  ungroup()

usethis::use_data(region_isos, overwrite = TRUE)
