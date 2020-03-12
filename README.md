
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
(Paris Agreement Capital Transition Assessment). ‘PACTA’ is a free tool
that calculates the alignment between financial assets and climate
scenarios (<https://www.transitionmonitor.com/>). Banks, for example,
use it to test if their corporate lending portfolios align with a
benchmark of two degrees Celsius, and thus to understand how the money
they lend may impact the climate. Because financial institutions keep
their data private, this package provides public datasets to help build
and train users of ‘PACTA’ in R.

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

data_dictionary()
#> # A tibble: 66 x 4
#>    dataset  column             typeof  definition                               
#>    <chr>    <chr>              <chr>   <chr>                                    
#>  1 ald_demo ald_timestamp      charac… Date at which asset data was pulled from…
#>  2 ald_demo country_of_domici… charac… Country where company is registered      
#>  3 ald_demo emission_factor    double  Company level emission factor of the tec…
#>  4 ald_demo is_ultimate_liste… logical Flag if company is the listed ultimate p…
#>  5 ald_demo is_ultimate_owner  logical Flag if company is the ultimate parent i…
#>  6 ald_demo name_company       charac… The name of the company owning the asset 
#>  7 ald_demo number_of_assets   integer Number of assets of a given technology o…
#>  8 ald_demo plant_location     charac… Country where asset is located           
#>  9 ald_demo production         double  Company level production of the technolo…
#> 10 ald_demo production_unit    charac… The units that production is measured in 
#> # … with 56 more rows
```

[Go to examples](https://2degreesinvesting.github.io/r2dii/#examples).
