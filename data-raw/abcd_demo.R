library(dplyr)
library(janitor)
library(pacta.data.preparation)
library(synthpop)
library(tibble)
library(tidyr)
library(withr)

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

# load data
# TODO: parameterize (or ideally point to a longstanding link on AFS)
# The goal would be to keep this as reproducible as possible if we try to re-run
# in 2 years
pams_path <- "/Users/jdhoffa/Downloads/AR_2022Q4/2023-02-15_AI_RMI_Advanced Company Indicators_2022Q4.xlsx"
pams <- pacta.data.preparation::import_ar_advanced_company_indicators(pams_path)

# company profiles as defined by George here:
# https://dev.azure.com/RMI-PACTA/2DegreesInvesting/_workitems/edit/7196
# TODO: I believe we can remove this tibble entirely, as I think it is just the
# top 5 companies per sector, by production.
companies <- tibble::tribble(
  ~data_demo_name, ~company_id,                                ~name_company,       ~sector,
  "large oil and gas company one",      41977L,                      "saudi arabian oil co.", "Oil&Gas",
  "large oil and gas company two",      14635L,           "china petroleum & chemical corp.", "Oil&Gas",
  "large oil and gas company three",      11608L,                       "petrochina co., ltd.", "Oil&Gas",
  "large oil and gas company four",       1101L,                          "exxon mobil corp.", "Oil&Gas",
  "large oil and gas company five",      41498L,                                  "shell plc", "Oil&Gas",
  "large coal company one",        943L,                             "bhp group ltd.",        "Coal",
  "large coal company two",      42471L,             "china shenhua energy co., ltd.",        "Coal",
  "large coal company three",      39412L,                         "anglo american plc",        "Coal",
  "large coal company four",      12781L,                            "coal india ltd.",        "Coal",
  "large coal company five",      19932L,                                  "ntpc ltd.",        "Coal",
  "large power company one",      34398L,                                  "uniper se",       "Power",
  "large power company two",      41306L,                                   "enel spa",       "Power",
  "large power company three",       6783L,                                    "e.on se",       "Power",
  "large power company four",      14249L,                                   "engie sa",       "Power",
  "large power company five",       6774L,                                 "siemens ag",       "Power",
  "large automotive company one",       6781L,                              "volkswagen ag",  "LDV",
  "large automotive company two",       6459L,                         "toyota motor corp.",  "LDV",
  "large automotive company three",     511963L,                              "stellantis nv",  "LDV",
  "large automotive company four",      27484L,                     "mercedes-benz group ag",  "LDV",
  "large automotive company five",       1126L,                             "ford motor co.",  "LDV",
  "large steel company one",      22950L,                           "arcelormittal sa",       "Steel",
  "large steel company two",       9825L,                        "posco holdings inc.",       "Steel",
  "large steel company three",       5892L,                         "nippon steel corp.",       "Steel",
  "large steel company four",      41047L,             "baoshan iron & steel co., ltd.",       "Steel",
  "large steel company five",       1442L,                                "nucor corp.",       "Steel",
  "large cement company one",       2200L, "china national building material co., ltd.",      "Cement",
  "large cement company two",       4222L,                                    "crh plc",      "Cement",
  "large cement company three",       6761L,                                "holcim ltd.",      "Cement",
  "large cement company four",      26362L,               "anhui conch cement co., ltd.",      "Cement",
  "large cement company five",       7575L,                        "heidelbergcement ag",      "Cement",
  "large aviation company one",       8035L,                      "delta air lines, inc.",    "Aviation",
  "large aviation company two",        841L,              "american airlines group, inc.",    "Aviation",
  "large aviation company three",       2321L,             "united airlines holdings, inc.",    "Aviation",
  "large aviation company four",       6765L,                      "deutsche lufthansa ag",    "Aviation",
  "large aviation company five",      14243L,                          "air france-klm sa",    "Aviation",
  "large hdv company one",     633684L,                   "daimler truck holding ag",         "HDV",
  "large hdv company two",       6729L,                                   "volvo ab",         "HDV",
  "large hdv company three",       6781L,                              "volkswagen ag",         "HDV",
  "large hdv company four",       1871L,                               "paccar, inc.",         "HDV"
)


# clean data
pams <- janitor::clean_names(pams)

desired_units <- tibble::tribble(
  ~activity_unit,          ~value_type, ~asset_sector,
  "tCO2/pkm", "emission_intensity",    "Aviation",
  "pkm",         "production",    "Aviation",
  "tCO2e/t cement", "emission_intensity",      "Cement",
  "t cement",         "production",      "Cement",
  "tCO2e/t coal", "emission_intensity",        "Coal",
  "t coal",         "production",        "Coal",
  "tCO2/km", "emission_intensity",         "LDV",
  "# vehicles", "production",         "LDV",
  "tCO2/km", "emission_intensity",         "HDV",
  "# vehicles", "production",         "HDV",
  "tCO2e/GJ", "emission_intensity",     "Oil&Gas",
  "GJ",         "production",     "Oil&Gas",
  "tCO2e/MWh", "emission_intensity",       "Power",
  "MW",         "production",       "Power",
  "tCO2/dwt km", "emission_intensity",    "Shipping",
  "dwt km",         "production",    "Shipping",
  "tCO2e/t steel", "emission_intensity",       "Steel",
  "t steel",         "production",       "Steel"
)

sector_bridge <- tibble::tribble(
  ~sector_old,   ~sector_new,
  "LDV",  "automotive",
  "Aviation",    "aviation",
  "Cement",      "cement",
  "Coal",        "coal",
  "HDV",         "hdv",
  "Oil&Gas", "oil and gas",
  "Power",       "power",
  "Shipping",    "shipping",
  "Steel",       "steel"
)

technology_bridge <- tibble::tribble(
  ~sector,            ~technology_old,           ~technology_new,
  "Aviation",                "Passenger",               "passenger",
  "Coal", "Bituminous Metallurgical",                    "coal",
  "Coal",       "Bituminous Thermal",                    "coal",
  "Coal",          "Lignite Thermal",                    "coal",
  "Coal",   "Sub-Bituminous Thermal",                    "coal",
  "Oil&Gas",                      "Gas",                     "gas",
  "Oil&Gas",      "Natural Gas Liquids",                     "gas",
  "Oil&Gas",       "Oil and Condensate",                     "oil",
  "LDV",                 "Electric",                "electric",
  "LDV",                "Fuel Cell",                "fuelcell",
  "LDV",           "Hybrid No-Plug",                  "hybrid",
  "LDV",           "Hybrid Plug-In",                  "hybrid",
  "LDV",                  "ICE CNG",                     "ice",
  "LDV",               "ICE Diesel",                     "ice",
  "LDV",                 "ICE E85+",                     "ice",
  "LDV",             "ICE Gasoline",                     "ice",
  "LDV",              "ICE Propane",                     "ice",
  "Steel",     "Basic Oxygen Furnace",                "bof shop",
  "Steel",     "Electric Arc Furnace", "ac-electric arc furnace",
  "HDV",                 "Electric",                "electric",
  "HDV",                "Fuel Cell",                "fuelcell",
  "HDV",           "Hybrid No-Plug",                  "hybrid",
  "HDV",                  "ICE CNG",                     "ice",
  "HDV",               "ICE Diesel",                     "ice",
  "HDV",             "ICE Gasoline",                     "ice",
  "HDV",              "ICE Propane",                     "ice",
  "HDV",             "ICE Hydrogen",                     "ice",
  "Cement",      "Integrated facility",     "integrated facility",
  "Power",                  "CoalCap",                 "coalcap",
  "Power",                   "GasCap",                  "gascap",
  "Power",                 "HydroCap",                "hydrocap",
  "Power",               "NuclearCap",              "nuclearcap",
  "Power",                   "OilCap",                  "oilcap",
  "Power",            "RenewablesCap",           "renewablescap",
  "Coal",       "Anthracite Thermal",                    "coal"
)

pams_reduced <- dplyr::right_join(
  pams,
  select(companies, company_id, sector),
  by = c(company_id = "company_id", asset_sector = "sector")
) %>%
  dplyr::right_join(desired_units) %>%
  dplyr::filter(!(company_id == 5892L & asset_sector != "Steel")) %>%
  dplyr::filter(consolidation_method == "Equity Ownership") %>%
  dplyr::filter(year %in% c(2020:2030)) %>%
  dplyr::mutate(
    asset_country = if_else(
      is.na(asset_country),
      country_of_domicile,
      asset_country
    )
  ) %>%
  dplyr::select(
    company_id,
    company_name,
    is_ultimate_parent,
    is_ultimate_listed_parent,
    sector = asset_sector,
    technology = asset_technology,
    technology_type = asset_technology_type,
    asset_country,
    value_type,
    value,
    year,
    unit = activity_unit
  ) %>%
  dplyr::distinct() %>%
  tidyr::pivot_wider(
    names_from = value_type,
    values_from = c(value, unit),
    values_fn = c(value = mean, unit = first)
  ) %>%
  dplyr::group_by(
    company_id,
    company_name,
    is_ultimate_parent,
    is_ultimate_listed_parent,
    sector,
    technology,
    technology_type,
    asset_country,
    unit_production,
    unit_emission_intensity,
    year
  ) %>%
  dplyr::summarize(
    production = sum(value_production),
    emission_intensity = mean(value_emission_intensity),
    .groups = "drop"
  )

pams_reduced <- droplevels.data.frame(pams_reduced)


# only include a single asset country
# pick the country with the highest production
top_countries <- pams_reduced %>%
  filter(!is.na(asset_country)) %>%
  group_by(company_id, asset_country, year) %>%
  summarize(production = sum(production)) %>%
  group_by(company_id) %>%
  filter(production == max(production)) %>%
  distinct(company_id, asset_country)

pams_reduced_single_asset_country <- pams_reduced %>%
  select(-asset_country) %>%
  left_join(top_countries)


# begin synthesis

for (sector_pick in unique(pams_reduced_single_asset_country$sector)) {

  sector_data <- filter(pams_reduced_single_asset_country, sector == sector_pick)
  sector_data <- droplevels.data.frame(sector_data)

  codebook.syn(sector_data)$tab

  sector_mysyn <- syn(sector_data)
  pams_syn <- if (exists("pams_syn")) {
    dplyr::bind_rows(pams_syn, sector_mysyn$syn)
  } else {
    sector_mysyn$syn
  }
}

pams_syn_cleaned <- pams_syn %>%
  dplyr::group_by(
    company_id,
    company_name,
    is_ultimate_parent,
    is_ultimate_listed_parent,
    sector,
    technology,
    asset_country,
    unit_production,
    unit_emission_intensity,
    year
  ) %>%
  dplyr::summarize(
    emission_intensity = mean(round(emission_intensity, 5)),
    production = mean(production)
  ) %>%
  dplyr::left_join(
    distinct(companies, data_demo_name, company_id),
    by = "company_id",
    relationship = "many-to-many"
  ) %>%
  mutate(
    company_name = data_demo_name,
    data_demo_name = NULL
  ) %>%
  group_by(company_name, sector) %>%
  filter(!is.na(company_name)) %>%
  mutate(
    company_id = as.character(dplyr::cur_group_id()),
  ) %>%
  ungroup() %>%
  filter(!is.na(production)) %>%
  select(
    company_id,
    name_company = company_name,
    sector,
    technology,
    production_unit = unit_production,
    emission_factor_unit = unit_emission_intensity,
    year,
    production,
    emission_factor = emission_intensity,
    country_of_domicile = asset_country,
    plant_location = asset_country,
    is_ultimate_owner = is_ultimate_listed_parent
  ) %>%
  mutate(
    abcd_timestamp = "2022Q4"
  )

# ensure reproducibility of random identifiers
withr::with_seed(
  42,
  {
    leis <- pams_syn_cleaned %>%
      # assume LEIs are unique by id_company
      distinct(company_id) %>%
      mutate(lei = vgenerate_lei(company_id))
  }
)

pams_syn_with_lei <- pams_syn_cleaned %>%
  left_join(leis, by = "company_id")

pams_with_correct_sector_techs <- pams_syn_with_lei %>%
  left_join(sector_bridge, by = c(sector = "sector_old")) %>%
  left_join(
    technology_bridge,
    by = c(sector = "sector", technology = "technology_old")
    ) %>%
  mutate(
    sector = sector_new,
    technology = technology_new,
    sector_old = NULL,
    sector_new = NULL,
    technology_old = NULL,
    technology_new = NULL
  )

emission_factor_sectors <- c("steel", "cement", "aviation")

pams_with_selected_emission_factors <- pams_with_correct_sector_techs %>%
  mutate(
    emission_factor = if_else(
      sector %in% emission_factor_sectors, emission_factor, NA
    ),
    emission_factor_unit = if_else(
      sector %in% emission_factor_sectors, emission_factor_unit, NA
    )
  )


abcd_demo <- pams_with_selected_emission_factors %>%
  select(
    company_id,
    name_company,
    lei,
    sector,
    technology,
    year,
    production,
    production_unit,
    emission_factor,
    emission_factor_unit,
    country_of_domicile,
    plant_location,
    is_ultimate_owner,
    abcd_timestamp
  )

usethis::use_data(abcd_demo, overwrite = TRUE)
