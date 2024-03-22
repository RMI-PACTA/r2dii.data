# r2dii.data (development version)

* `loanbook_demo` and `abcd_demo` gain sample entries for `lei_direct_loantaker` and `lei` respectively (#349).

* `nace_classification` updated to version `2.1` (#234).
* `nace_classification` gains more specific `code` values to distinguish duplicates (#338).
* `isic_classification` updated to revision `5` (#329).
* `psic_classification` gains `version` column (#344).
* `naics_classification` updated to version `2022` (#355).
* `gics_classification` updated to version `2023` (#358).
* `sic_classification` aligned against `1987` version of US SIC codes (#358).

* Begin deprecation of `cnb_classification` (#329).
* Complete deprecation of `ald_demo` in favor of `abcd_demo` (#328).
* Complete deprecation of `green_or_brown` in favor of `increasing_or_decreasing` (#307).

# r2dii.data 0.4.1

* Fix of the demo data sets.
* `abcd_demo` and `loanbook_demo` now use faked company names.

# r2dii.data 0.4.0

* New dataset `increasing_or_decreasing` supersedes the dataset 
`green_or_brown` (#307).

# r2dii.data 0.3.1

* `r2dii.data` has transferred to a new organization: 
https://github.com/RMI-PACTA/.

# r2dii.data 0.3.0

* New dataset `abcd_demo` supersedes the dataset `ald_demo` (#279). 
* `region_isos` gains data for new scenario `source`s: 'weo_2021', 'etp_2020', 
'geco_2020' and 'geco_2021'.
* `region_isos` gains country specific regions for 'weo_2019' and 'weo_2020' 
(#270 @julie-vienne).

# r2dii.data 0.2.2

* `region_isos` now outputs all expected `region`s for: `weo_2020` and 
  `isf_2020` (#253 @Antoine-Lalechere).

# r2dii.data 0.2.1

* `region_isos` gains data for new scenario `source`s: `weo_2020`, `isf_2020` 
and `nze_2021` (#241 @georgeharris2deg). 

# r2dii.data 0.2.0

* `ald_demo` and `scenario_demo_2020` gain rows of dummy data for the `hdv`
(heavy-duty vehicle) sector (#231).
* `ald_demo` gains the column `lei`and loses the column
`is_ultimate_listed_owner`. Also the column `id_company` becomes `company_id`
and `ald_emission_factor_unit` becomes `emission_factor_unit` (#233).
* In `ald_demo`, the column `id_company` is now unique for each `name_company`
and `sector` pair (#232).
* In all sector classification datasets, the column `code` is now consistently
of type "character".

# r2dii.data 0.1.9

* In `sector_classifications` and `psic_classification`, all values of `sector`
  are now lowercase (#222 @daisy-pacheco).

# r2dii.data 0.1.8

* Remove leading zeroes from the column `code` of the dataset
`psic_classification` (#218 @daisy-pacheco).
* `ald_demo` gains column `id_company` (@vintented #197).
* `nace_classification` codes for automotive sales now have `borderline` values 
  of `TRUE` (@KapitanKombajn #213).

# r2dii.data 0.1.7

* Add heavy-duty vehicles to `green_or_brown`, `loanbook_demo`, and `ald_demo`
  (@vintented #131).
* New dataset `psic_classification` (@daisy-pacheco #199).

# r2dii.data 0.1.6

* `region_isos` now correctly maps Kosovo iso to "xk" (@cjyetman #186).
* `region_isos` now includes more missing isos for all `global` regions (#183).
* Add missing sectors to `nace_classification` (@georgeharris2deg #171). 
* Fix borderline definitions in `isic_classification` and `nace_classification` 
  (@georgeharris2deg #163).
* New dataset `cnb_classification` (@georgeharris2deg #173).

# r2dii.data 0.1.4

* Change license to CC0; it's the most appropriate for sharing data (#161).
* New dataset `gics_classification` (@georgeharris2deg #162).
* The definition of `borderline` is now clearer (@georgeharris2deg #163).

# r2dii.data 0.1.3

* Change license to MIT.
* The website's home page now acknowledges funders.
* The website's home page now reports test coverage.
* The "News" tab of the website now shows all releases to date.
* Replace 'ton' and 'tons' with 'tonne' and 'tonnes' (#134).
* Fix typos in columns definitions.

# r2dii.data 0.1.2

* `region_isos` no longer has duplicated rows (@jdhoffa #111).
* New dataset `green_or_brown` (#124).
* New dataset `sic_classification` (@georgeharris2deg, @daisy-pacheco #125).
* `ald_demo` drops the column `number_of_assets` (@tposey28 #121).
* `region_isos` gains data from ETP 2017 (@jdhoffa #110).
* Require R >= 3.4, which is what we check for (@maurolepore #117).

# r2dii.data 0.1.1

* `naics_classification` now includes only 6-digit codes (@QianFeng2020 #102; @jdhoffa #103).

# r2dii.data 0.1.0

* r2dii.data is now [maturing](https://lifecycle.r-lib.org/articles/stages.html).
* `naics_classification` now includes correct data (@QianFeng2020 #85; @maurolepore #94).
* `region_isos` now includes a "global" `region` (@jdhoffa #52).
* `region_isos` gains the column `source` and updates from WEO2019 (@jdhoffa
  #50).
* `ald_demo` gains the column `ald_emission_factor_unit` (#71).
* New dataset `co2_intensity_scenario_demo` (@jdhoffa #83).
* New dataset `region_isos_demo` (#60).
* New dataset `scenario_demo_2020` (#37).

# r2dii.data 0.0.3

* First release on CRAN.
