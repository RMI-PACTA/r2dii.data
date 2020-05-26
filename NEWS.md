# r2dii.data 0.0.3.9006 (development version)

* New dataset `co2_intensity_scenario_demo` (@jdhoffa #83).
* Reproduce data from data-raw and test on CI (#61).
* Remove columns definition from help files; use `data_dictionary` (#63).
* Dataset `ald_demo` gains the column `ald_emission_factor_unit` (#71).
* New dataset `region_isos_demo` (#60).
* `region_isos` now includes a "global" `region` (@jdhoffa #52).
* `region_isos` gains column `source` and updates from WEO2019 (@jdhoffa #50).
* New `ald_scenario_demo` combines ald with scenario data, uses a streamlined ald, and excludes needless columns. (#22, #28, #32). 
* Removed the attribute "spec" and class "spec_tbl_df" from all datasets (#43).
* New data `scenario_demo_2020` (#37).
* `?r2dii.data` now shows documentation at the package level (#25).
* The website now links the changelog and release notes under News (#27).

# r2dii.data 0.0.3

* First release on CRAN.
