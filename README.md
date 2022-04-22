
<!-- README.md is generated from README.Rmd. Please edit that file -->

# r2dii.data <img src="man/figures/logo.svg" align="right" width="120" />

<!-- badges: start -->

[![Lifecycle:
maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://lifecycle.r-lib.org/articles/stages.html)
[![CRAN
status](https://www.r-pkg.org/badges/version/r2dii.data)](https://CRAN.R-project.org/package=r2dii.data)
[![](https://cranlogs.r-pkg.org/badges/grand-total/r2dii.data)](https://CRAN.R-project.org/package=r2dii.data)
[![Codecov test
coverage](https://codecov.io/gh/2DegreesInvesting/r2dii.data/branch/main/graph/badge.svg)](https://codecov.io/gh/2DegreesInvesting/r2dii.data?branch=main)
[![R-CMD-check](https://github.com/2DegreesInvesting/r2dii.data/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/2DegreesInvesting/r2dii.data/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

These datasets support the implementation in R of the software PACTA
(Paris Agreement Capital Transition Assessment), which is a free tool
that calculates the alignment between financial assets and climate
scenarios (<https://2degrees-investing.org/>). Financial institutions
use PACTA to study how their capital allocation impacts the climate.
Because both financial institutions and market data providers keep their
data private, this package provides fake, public data to enable the
development and use of PACTA in R.

## Installation

Install the released version of r2dii.data from CRAN with:

``` r
install.packages("r2dii.data")
```

Or install the development version of r2dii.data with something like
this:

``` r
# install.packages("devtools")
devtools::install_github("2DegreesInvesting/r2dii.data")
```

[How to raise an
issue?](https://2degreesinvesting.github.io/posts/2020-06-26-instructions-to-raise-an-issue/)

## Example

``` r
library(r2dii.data)

head(data_dictionary)
#>    dataset               column    typeof
#> 1 ald_demo        ald_timestamp character
#> 2 ald_demo           company_id character
#> 3 ald_demo  country_of_domicile character
#> 4 ald_demo      emission_factor    double
#> 5 ald_demo emission_factor_unit character
#> 6 ald_demo    is_ultimate_owner   logical
#>                                                            definition
#> 1         Date at which asset data was sourced from the data provider
#> 2 The id of the company owning the asset created by the data provider
#> 3                                 Country where company is registered
#> 4                     Company level emission factor of the technology
#> 5                   The units that the emission factor is measured in
#> 6              Flag if company is the ultimate parent in our database
```

## Funding

This project has received funding from the [European Union LIFE
program](https://wayback.archive-it.org/12090/20210412123959/https://ec.europa.eu/easme/en/)
and the [International Climate Initiative
(IKI)](https://www.international-climate-initiative.com/en/details/project/measuring-paris-agreement-alignment-and-financial-risk-in-financial-markets-18_I_351-2982).
The Federal Ministry for the Environment, Nature Conservation and
Nuclear Safety (BMU) supports this initiative on the basis of a decision
adopted by the German Bundestag. The views expressed are the sole
responsibility of the authors and do not necessarily reflect the views
of the funders. The funders are not responsible for any use that may be
made of the information it contains.
