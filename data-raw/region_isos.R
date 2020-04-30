# # Source:
# # * raw_regions_weo2019.csv was transcribed from page 780 of the 2019 World Energy Outlook
#
# path <- here::here("data-raw/region_isos.rds")
# region_isos <- readr::read_rds(path) %>%
#   purrr::map_df(tibble::as_tibble, .id = "region") %>%
#   dplyr::rename(isos = .data$value)
#
# usethis::use_data(region_isos, overwrite = TRUE)


#-------------------------------
# Source:
# * raw_regions_weo2019.csv was transcribed from page 780 of the 2019 World Energy Outlook
paths <- list.files(here::here("data-raw/region_isos"), full.names = TRUE)

raw_region_data <- lapply(
  paths,
  function(.x) {
    utils::read.csv(
      .x,
      colClasses = "character",
      na.strings = c("", "NA"),
      stringsAsFactors = FALSE
    )
  }
)

region_data_tibble<- Reduce(rbind, raw_region_data) %>%
  tibble::as_tibble()

region_country_name <- dplyr::filter(region_data_tibble, type == "country_name") %>%
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

out_only_countries <- rbind(region_country_name, leftover_regions_expanded_by_country) %>%
  dplyr::arrange(region)

# these are tough to expand programatically
leftover_special_regions <- dplyr::filter(region_data_tibble, type == "special_region") %>%
  dplyr::select(-type)

leftover_special_regions

all_countries <- out_only_countries %>%
  dplyr::select(value) %>%
  unique()

advanced_economies <- dplyr::filter(out_only_countries, region == "advanced economies")

developing_economies <- all_countries %>%
  dplyr::filter(!(value %in% advanced_economies$value)) %>%
  dplyr::mutate(region = "developing economies", source = "weo2019")

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
  dplyr::mutate(region = "non oecd", source = "weo2019")

opec <- dplyr::filter(out_only_countries, region == "opec")

non_opec <- all_countries %>%
  dplyr::filter(!(value %in% opec$value)) %>%
  dplyr::mutate(region = "non opec", source = "weo2019")

# # check how many countries dont match their isos
# fix <- rbind(out_only_countries, developing_economies, iea, non_oecd, non_opec) %>%
#   dplyr::left_join(r2dii.data::iso_codes, by = c("value" = "country")) %>%
#   dplyr::filter(is.na(country_iso))

region_isos <- rbind(out_only_countries, developing_economies, iea, non_oecd, non_opec) %>%
  dplyr::left_join(r2dii.data::iso_codes, by = c("value" = "country")) %>%
  dplyr::filter(!is.na(country_iso)) %>%
  dplyr::rename(isos = country_iso) %>%
  dplyr::select(region, isos, source)

usethis::use_data(region_isos, overwrite = TRUE)
