
<!-- README.md is generated from README.Rmd. Please edit that file -->

# r2dii.data <img src="man/figures/logo.png" align="right" width="120" />

<!-- badges: start -->

[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![CRAN
status](https://www.r-pkg.org/badges/version/r2dii.data)](https://CRAN.R-project.org/package=r2dii.data)
[![](https://cranlogs.r-pkg.org/badges/grand-total/r2dii.data)](https://CRAN.R-project.org/package=r2dii.data)
[![Codecov test
coverage](https://codecov.io/gh/RMI-PACTA/r2dii.data/branch/main/graph/badge.svg)](https://app.codecov.io/gh/RMI-PACTA/r2dii.data?branch=main)
[![R-CMD-check](https://github.com/RMI-PACTA/r2dii.data/actions/workflows/R.yml/badge.svg)](https://github.com/RMI-PACTA/r2dii.data/actions/workflows/R.yml)
<!-- badges: end -->

These datasets support the implementation in R of the software PACTA
(Paris Agreement Capital Transition Assessment), which is a free tool
that calculates the alignment between financial assets and climate
scenarios. Financial institutions use PACTA to study how their capital
allocation impacts the climate. Because both financial institutions and
market data providers keep their data private, this package provides
fake, public data to enable the development and use of PACTA in R.

## Installation

Install the released version of r2dii.data from CRAN with:

``` r
install.packages("r2dii.data")
```

Or install the development version of r2dii.data with something like
this:

``` r
# install.packages("pak")
pak::pak("RMI-PACTA/r2dii.data")
```

## Example

``` r
library(r2dii.data)

head(data_dictionary)
#>     dataset               column    typeof
#> 1 abcd_demo           company_id character
#> 2 abcd_demo      emission_factor    double
#> 3 abcd_demo emission_factor_unit character
#> 4 abcd_demo    is_ultimate_owner   logical
#> 5 abcd_demo                  lei character
#> 6 abcd_demo         name_company character
#>                                                            definition
#> 1 The id of the company owning the asset created by the data provider
#> 2                     Company level emission factor of the technology
#> 3                   The units that the emission factor is measured in
#> 4              Flag if company is the ultimate parent in our database
#> 5         The legal entity identifier of the company owning the asset
#> 6                            The name of the company owning the asset
```

## Funding

This project has received funding from the [European Union LIFE
program](https://wayback.archive-it.org/12090/20210412123959/https://ec.europa.eu/easme/en/)
and the [International Climate Initiative
(IKI)](https://www.international-climate-initiative.com/en/search-project/).
The Federal Ministry for the Environment, Nature Conservation and
Nuclear Safety (BMU) supports this initiative on the basis of a decision
adopted by the German Bundestag. The views expressed are the sole
responsibility of the authors and do not necessarily reflect the views
of the funders. The funders are not responsible for any use that may be
made of the information it contains.
