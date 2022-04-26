library(dplyr)
library(usethis)

source(file.path("data-raw", "utils.R"))

generate_lei <- function(id) {
  # function to generate random but reproducible LEIs
  # 4 characters, 2 zeroes, 12 characters, 2 check digits
  alpha_num <- c(0:9, LETTERS)

  withr::with_seed(
    id,
    {
      four <- do.call(
        paste0,
        replicate(4, sample(0:9, 1, TRUE), FALSE)
      )

      twelve <- do.call(
        paste0,
        replicate(12, sample(alpha_num, 1, TRUE), FALSE)
      )

      two <- do.call(
        paste0,
        replicate(2, sample(0:9, 1, TRUE), FALSE)
      )
    }
  )

  paste0(four, "00", twelve, two)
}

vgenerate_lei <- Vectorize(generate_lei)

path <- file.path("data-raw", "ald_demo.csv")
ald_demo <- read_csv_(path)

# ensure aviation data is in appropriate range
ald_aviation <- ald_demo %>%
  dplyr::filter(sector == "aviation")

ald_aviation <- ald_aviation %>%
  dplyr::group_by(year) %>%
  dplyr::filter(!is.na(emission_factor)) %>%
  dplyr::mutate(
    # normalize the data
    .x = production,
    .y = emission_factor,
    production = (.x - min(.x)) / (max(.x) - min(.x)),
    emission_factor = (.y - min(.y)) / (max(.y) - min(.y)),
    .x = NULL,
    .y = NULL
  )

ald_aviation <- ald_aviation %>%
  dplyr::group_by(year) %>%
  dplyr::mutate(
    # normalize the data
    .x = production,
    .y = emission_factor,
    production = (.x * (76713 - 0)) + 0,
    emission_factor = (.y * (0.0012 - 0.000092)) + 0.000092,
    .x = NULL,
    .y = NULL
  )

# hdv ---------------------------------------------------------------------
hdv_name_bridge <- tibble::tribble(
  ~name_company, ~name_company_hdv,
  "aston martin", "scania",
  "avtozaz", "man",
  "bogdan", "iveco",
  "ch auto", "paccar inc",
  "chehejia", "hino",
  "chtc auto", "volvo group",
  "dongfeng honda", "navistar",
  "dongfeng-luxgen", "dongfeng",
  "electric mobility solutions", "tata motors",
  "faraday future", "daimler"
)

ald_hdv <- ald_demo %>%
  dplyr::filter(sector == "automotive") %>%
  dplyr::mutate(
    sector = "hdv"
  ) %>%
  dplyr::right_join(hdv_name_bridge, by = "name_company") %>%
  dplyr::select(-name_company) %>%
  dplyr::rename(name_company = name_company_hdv)

# then we will ensure the numerical fields are in an appropriate range
# we will also add some random noise to ensure that the output isn't identical
# to the cement output
ald_hdv <- ald_hdv %>%
  dplyr::group_by(year) %>%
  dplyr::filter(!is.na(emission_factor)) %>%
  dplyr::mutate(
    # normalize the data
    .x = production,
    production = (.x - min(.x)) / (max(.x) - min(.x)),
    emission_factor = NA,
    .x = NULL,
  )

ald_hdv <- ald_hdv %>%
  dplyr::group_by(year) %>%
  dplyr::mutate(
    # normalize the data
    .x = production,
    production = (.x * (361639 - 0)) + 0,
    .x = NULL,
  )

ald_demo <- ald_demo %>%
  dplyr::filter(!(grepl("hdv", technology))) %>%
  dplyr::bind_rows(
    ald_hdv
  )

ald_demo <- left_join(
  ald_demo, new_emission_factor_unit(),
  by = "sector"
)

ald_demo$year <- as.integer(ald_demo$year)

ald_demo <- ald_demo %>%
  group_by(name_company, sector) %>%
  mutate(
    id_company = as.character(cur_group_id()),
    .before = 1
  ) %>%
  ungroup()

# ensure reproducibility of random identifiers
withr::with_seed(
  42,
  {
    leis <- ald_demo %>%
      # assume only LEIs for ultimate_parents
      filter(is_ultimate_owner == TRUE) %>%
      # assume LEIs are unique by id_company
      select(id_company) %>%
      unique() %>%
      # assume LEIs for about 50% of companies
      slice_sample(prop = 0.5) %>%
      mutate(lei = vgenerate_lei(id_company))
  }
)

ald_demo <- ald_demo %>%
  left_join(leis, by = "id_company")

ordered_names <- c(
  company_id = "id_company",
  "name_company",
  "lei",
  "sector",
  "technology",
  "production_unit",
  "year",
  "production",
  "emission_factor",
  "country_of_domicile",
  "plant_location",
  "is_ultimate_owner",
  "ald_timestamp",
  emission_factor_unit = "ald_emission_factor_unit"
)

ald_demo <- select(ald_demo, ordered_names)

abcd_demo <- rename(ald_demo, abcd_timestamp = ald_timestamp)

usethis::use_data(ald_demo, overwrite = TRUE)
usethis::use_data(abcd_demo, overwrite = TRUE)
