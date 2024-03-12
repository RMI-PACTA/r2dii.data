library(charlatan)
library(dplyr)
library(readr)
library(stringi)
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

path <- file.path("data-raw", "abcd_demo.csv")
abcd_demo <- read_csv(path, na = "", show_col_types = FALSE)

# ensure time frame corresponds to typical format of a P4B data release (five
# years forward looking)
abcd_demo <- abcd_demo %>%
  dplyr::filter(
    dplyr::between(year, 2020, 2025)
  )

# set ald_timestamp to a reasonable value give the time frame of the demo data
abcd_demo <- abcd_demo %>%
  dplyr::mutate(
    ald_timestamp = "2020Q4"
  )

# ensure aviation data is in appropriate range
abcd_aviation <- abcd_demo %>%
  dplyr::filter(sector == "aviation")

abcd_aviation <- abcd_aviation %>%
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

abcd_aviation <- abcd_aviation %>%
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

locales <- c("de_DE", "en_US", "it_IT")

abcd_hdv <- abcd_demo %>%
  dplyr::filter(sector == "automotive") %>%
  dplyr::mutate(sector = "hdv") %>%
  mutate(
    name_company = paste0(ch_company(locale = locales[sample.int(n = length(locales), size = 1)]), " (", sector, ")"),
    .by = name_company
  ) %>%
  mutate(name_company = gsub("&amp;", "&", name_company)) %>%
  mutate(name_company = stri_trans_general(name_company, id = "Latin-ASCII"))

# then we will ensure the numerical fields are in an appropriate range
# we will also add some random noise to ensure that the output isn't identical
# to the cement output
abcd_hdv <- abcd_hdv %>%
  dplyr::group_by(year) %>%
  dplyr::filter(!is.na(emission_factor)) %>%
  dplyr::mutate(
    # normalize the data
    .x = production,
    production = (.x - min(.x)) / (max(.x) - min(.x)),
    emission_factor = NA,
    .x = NULL,
  )

abcd_hdv <- abcd_hdv %>%
  dplyr::group_by(year) %>%
  dplyr::mutate(
    # normalize the data
    .x = production,
    production = (.x * (361639 - 0)) + 0,
    .x = NULL,
  )

abcd_demo <- abcd_demo %>%
  dplyr::filter(!(grepl("hdv", technology))) %>%
  dplyr::bind_rows(
    abcd_hdv
  )

abcd_demo <- left_join(
  abcd_demo, new_emission_factor_unit(),
  by = "sector"
)

abcd_demo$year <- as.integer(abcd_demo$year)

abcd_demo <- abcd_demo %>%
  group_by(name_company) %>%
  mutate(
    id_company = as.character(cur_group_id()),
    .before = 1
  ) %>%
  ungroup()

# ensure reproducibility of random identifiers
withr::with_seed(
  42,
  {
    leis <- abcd_demo %>%
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

abcd_demo <- abcd_demo %>%
  left_join(leis, by = "id_company")

abcd_demo <- abcd_demo %>%
  mutate(
    name_company = dplyr::case_when(
      name_company == "holcim hüttenzement" ~ "holcim huettenzement",
      name_company == "sa tudela veguín" ~ "sa tudela veguin",
      TRUE ~ name_company
    )
  )

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

abcd_demo <- select(abcd_demo, all_of(ordered_names))

abcd_demo <- rename(abcd_demo, abcd_timestamp = ald_timestamp)


# hot fixes for late 2023 release ----------------------------------------------

# remove Shipping data
abcd_demo <- filter(abcd_demo, sector != "shipping")

# remove LEIs
abcd_demo <- mutate(abcd_demo, lei = NA)

# stop if there are duplicate company names with different IDs
stopifnot(
  !abcd_demo %>%
    distinct(company_id, name_company) %>%
    pull(name_company) %>%
    duplicated() %>%
    any()
)


# export -----------------------------------------------------------------------

usethis::use_data(abcd_demo, overwrite = TRUE)
