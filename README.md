
<!-- README.md is generated from README.Rmd. Please edit that file -->

# <img src="https://i.imgur.com/3jITMq8.png" align="right" height=40 /> Datasets to Align Financial Markets with Climate Goals

<!-- badges: start -->

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/r2dii.data)](https://CRAN.R-project.org/package=r2dii.data)
<!-- badges: end -->

These datasets support the implementation in R of the software ‘PACTA’
(Paris Agreement Capital Transition Assessment), which is a free tool
that calculates the alignment between financial assets and climate
scenarios (<https://2degrees-investing.org/>). Financial institutions
use ‘PACTA’ to study how their capital allocation impacts the climate.
Because both financial institutions and market data providers keep their
data private, this package provides fake, public data to enable the
development and use of ‘PACTA’ in R.

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

[How to minimize installation
errors?](https://gist.github.com/maurolepore/a0187be9d40aee95a43f20a85f4caed6#installation)

## Example

``` r
library(r2dii.data)

head(data_dictionary)
#>    dataset                   column    typeof
#> 1 ald_demo            ald_timestamp character
#> 2 ald_demo      country_of_domicile character
#> 3 ald_demo          emission_factor    double
#> 4 ald_demo is_ultimate_listed_owner   logical
#> 5 ald_demo             name_company character
#> 6 ald_demo         number_of_assets   integer
#>                                                    definition
#> 1           Date at which asset data was pulled from database
#> 2                         Country where company is registered
#> 3             Company level emission factor of the technology
#> 4               Flag if company is the listed ultimate parent
#> 5                    The name of the company owning the asset
#> 6 Number of assets of a given technology owned by the company
```
