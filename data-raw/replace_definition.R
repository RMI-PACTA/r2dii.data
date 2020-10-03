library(devtools)
library(tidyverse)
library(here)
library(glue)

target_column <-"borderline"
new_definition <- "Flag indicating if 2dii sector and classification code are a borderline match. The value TRUE indicates that the match is uncertain between the 2dii sector and the classification. The value FALSE indicates that the match is certainly perfect or the classification is certainly out of 2dii's scope."

load_all()
datasets <- enlist_datasets("r2dii.data")

has_target_column <- function(data) hasName(data, target_column)

with_target_column <- datasets %>%
  keep(has_target_column) %>%
  names()

paths <- here("data-raw/data_dictionary", glue("{with_target_column}.csv"))

dataframes <- map(paths, read_csv) %>%
  set_names(with_target_column)


with_new_definition <- dataframes %>%
  map(
    ~mutate(., definition = case_when(
        column == target_column ~ new_definition,
        TRUE ~ definition
      )
    )
  )

walk2(with_new_definition, paths, write_csv)
