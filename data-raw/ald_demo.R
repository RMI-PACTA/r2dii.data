library(dplyr)
library(usethis)

source(file.path("data-raw", "utils.R"))

generate_lei <- function(id) {
  # function to generate random but reproducible LEIs
  # 4 characters, 2 zeroes, 12 characters, 2 check digits
  set.seed(id)

  alpha_num <- c(0:9, LETTERS)

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

  paste0(four, "00", twelve, two)
}

vgenerate_lei <- Vectorize(generate_lei)

generate_isin <- function(id, plant_location) {
  # function to generate random but reproducible ISINs
  # 2 characters for company location, 10 numbers
  set.seed(id)

  paste0(
    plant_location,
    do.call(paste0,replicate(10, sample(0:9, 1, TRUE), FALSE))
  )
}

vgenerate_isin <- Vectorize(generate_isin)

path <- file.path("data-raw", "ald_demo.csv")
ald_demo <- read_csv_(path)

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

#ensure reproducibility of random identifiers
set.seed(42)

leis <- ald_demo %>%
  # assume only LEIs for ultimate_parents
  filter(is_ultimate_owner == TRUE) %>%
  # assume LEIs are unique by id_company
  select(id_company) %>%
  unique() %>%
  # assume LEIs for about 50% of companies
  slice_sample(prop = 0.5) %>%
  mutate(lei_company = vgenerate_lei(id_company))

isins <- ald_demo %>%
  # assume ISINs are unique by id_company
  select(id_company, plant_location) %>%
  unique() %>%
  # assume ISINs for about 75% of companies
  slice_sample(prop = 0.75) %>%
  mutate(isin_company = vgenerate_isin(id_company, plant_location))

ald_demo <- ald_demo %>%
  left_join(leis, by = "id_company") %>%
  left_join(isins, by = c("id_company", "plant_location"))

ordered_names <- c(
  "id_company",
  "name_company",
  "lei_company",
  "isin_company",
  "sector",
  "technology",
  "production_unit",
  "year",
  "production",
  "emission_factor",
  "country_of_domicile",
  "plant_location",
  "is_ultimate_owner",
  "is_ultimate_listed_owner",
  "ald_timestamp",
  "ald_emission_factor_unit"
  )

ald_demo <- select(ald_demo, ordered_names)

usethis::use_data(ald_demo, overwrite = TRUE)
