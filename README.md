
<!-- README.md is generated from README.Rmd. Please edit that file -->

# <img src="https://i.imgur.com/3jITMq8.png" align="right" height=40 /> r2dii.data

<!-- badges: start -->

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/r2dii.data)](https://CRAN.R-project.org/package=r2dii.data)
[![Codecov test
coverage](https://codecov.io/gh/2DegreesInvesting/r2dii.data/branch/master/graph/badge.svg)](https://codecov.io/gh/2DegreesInvesting/r2dii.data?branch=master)
<!-- badges: end -->

These datasets support the implementation in R of the software ‘PACTA’
(Paris Agreement Capital Transition Assessment), which is a free tool
that calculates the alignment between financial assets and climate
scenarios (<https://www.transitionmonitor.com/>). Banks, for example,
use ‘PACTA’ to study how the money they lend impacts the climate.
Because financial institutions keep their data private, this package
provides fake, public data to enable the development and use of ‘PACTA’
in R.

## Installation

Install the development version of r2dii.data with something like this:

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
#> 5 ald_demo        is_ultimate_owner   logical
#> 6 ald_demo             name_company character
#>                                               definition
#> 1      Date at which asset data was pulled from database
#> 2                    Country where company is registered
#> 3        Company level emission factor of the technology
#> 4          Flag if company is the listed ultimate parent
#> 5 Flag if company is the ultimate parent in our database
#> 6               The name of the company owning the asset
```

[Go to examples](https://2degreesinvesting.github.io/r2dii/#examples).
