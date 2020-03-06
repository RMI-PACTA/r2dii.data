# Source: @jdhoffa
path <- here::here("data-raw/region_isos.rds")
region_isos <- readr::read_rds(path) %>%
  purrr::map_df(tibble::as_tibble, .id = "region") %>%
  dplyr::rename(isos = .data$value)

usethis::use_data(region_isos, overwrite = TRUE)
