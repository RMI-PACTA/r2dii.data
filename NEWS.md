# r2dii.data 0.0.3.9006 (development version)

* New `ald_scenario_demo` combines ald with scenario data, uses a streamlined ald, and excludes needless columns. (#22, #28, #32). 

## Next CRAN release

## User-facing

Added:
* New dataset `co2_intensity_scenario_demo` (@jdhoffa #83).
* New dataset `region_isos_demo` (#60).
* New dataset `scenario_demo_2020` (#37).

Changed:
* `ald_demo` gains the column `ald_emission_factor_unit` (#71).
* `region_isos` now includes a "global" `region` (@jdhoffa #52).
* `region_isos` gains column `source` and updates from WEO2019 (@jdhoffa #50).

### Developer-facing

* Dataset columns are now defined under `@format` in a dynamic way (#63).
* Datasets in data-raw/ are now reproduced and tested on GitHub Actions (#61).
* Datasets no longer have attribute "spec" and class "spec_tbl_df" (#43).
* `?r2dii.data` now shows documentation at the package level (#25).
* The website now includes a News menu 
* The package-website includes the changelog and release notes under News (#27).

# r2dii.data 0.0.3

* First release on CRAN.
