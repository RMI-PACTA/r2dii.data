# Source:
# * raw_regions_weo2019.csv was transcribed from page 780 of the 2019 World
# Energy Outlook
this_source <- "weo2019"
path <- here::here("data-raw/region_isos_weo2019.csv")

region_data_tibble <- utils::read.csv(
  path,
  colClasses = "character",
  na.strings = c("", "NA"),
  stringsAsFactors = FALSE
) %>%
  tibble::as_tibble()

region_country_name <- region_data_tibble %>%
  dplyr::filter(type == "country_name") %>%
  dplyr::select(-type)

# some regions are cyclically defined using other regions in the raw data
# we need to expand these and join them back in
leftover_regions <- dplyr::filter(region_data_tibble, type == "region") %>%
  dplyr::select(-type)

leftover_regions_expanded_by_country <- leftover_regions %>%
  dplyr::select(region, value) %>%
  dplyr::left_join(region_country_name, by = c("value" = "region")) %>%
  dplyr::select(-value) %>%
  dplyr::rename(value = value.y)

out_only_countries <- region_country_name %>%
  rbind(leftover_regions_expanded_by_country) %>%
  dplyr::arrange(region)

all_countries <- out_only_countries %>%
  dplyr::select(value) %>%
  unique()

global <- all_countries %>%
  dplyr::mutate(region = "global", source = this_source)

advanced_economies <- out_only_countries %>%
  dplyr::filter(region == "advanced economies")

developing_economies <- all_countries %>%
  dplyr::filter(!(value %in% advanced_economies$value)) %>%
  dplyr::mutate(region = "developing economies", source = this_source)

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
  dplyr::mutate(region = "non oecd", source = this_source)

opec <- dplyr::filter(out_only_countries, region == "opec")

non_opec <- all_countries %>%
  dplyr::filter(!(value %in% opec$value)) %>%
  dplyr::mutate(region = "non opec", source = this_source)

# check how many countries dont match their isos
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

region_isos <- out_only_countries %>%
  rbind(global, developing_economies, iea, non_oecd, non_opec) %>%
  dplyr::left_join(r2dii.data::iso_codes, by = c("value" = "country")) %>%
  dplyr::filter(!is.na(country_iso)) %>%
  dplyr::rename(isos = country_iso) %>%
  dplyr::select(region, isos, source)

usethis::use_data(region_isos, overwrite = TRUE)
