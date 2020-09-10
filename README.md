
<!-- README.md is generated from README.Rmd. Please edit that file -->

# r2dii.data <a href='https://github.com/2DegreesInvesting/r2dii.data'><img src='https://imgur.com/A5ASZPE.png' align='right' height='43' /></a>

<!-- badges: start -->

[![Lifecycle:
maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![CRAN
status](https://www.r-pkg.org/badges/version/r2dii.data)](https://CRAN.R-project.org/package=r2dii.data)
[![](https://cranlogs.r-pkg.org/badges/grand-total/r2dii.data)](https://CRAN.R-project.org/package=r2dii.data)
[![R build
status](https://github.com/2DegreesInvesting/r2dii.data/workflows/R-CMD-check/badge.svg)](https://github.com/2DegreesInvesting/r2dii.data/actions)
[![Codecov test
coverage](https://codecov.io/gh/2DegreesInvesting/r2dii.data/branch/master/graph/badge.svg)](https://codecov.io/gh/2DegreesInvesting/r2dii.data?branch=master)
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

Before you install r2dii.analysis you may want to:

  - [Try an rstudio.cloud project with this package already
    installed](https://rstudio.cloud/project/1424833).
  - [Learn how to minimize installation
    errors](https://gist.github.com/maurolepore/a0187be9d40aee95a43f20a85f4caed6#installation).

When you are ready, install the released version of r2dii.data from CRAN
with:

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
#>    dataset                   column    typeof
#> 1 ald_demo ald_emission_factor_unit character
#> 2 ald_demo            ald_timestamp character
#> 3 ald_demo      country_of_domicile character
#> 4 ald_demo          emission_factor    double
#> 5 ald_demo is_ultimate_listed_owner   logical
#> 6 ald_demo        is_ultimate_owner   logical
#>                                                    definition
#> 1           The units that the emission factor is measured in
#> 2 Date at which asset data was sourced from the data provider
#> 3                         Country where company is registered
#> 4             Company level emission factor of the technology
#> 5               Flag if company is the listed ultimate parent
#> 6      Flag if company is the ultimate parent in our database
```

``` r
download.file("http://bit.ly/banks-thanks", thanks <- tempfile())
```

## Acknowledgements

This project has received funding from the [European Union LIFE
program](https://ec.europa.eu/easme/en/life) and the [International
Climate Initiative (IKI)](https://bit.ly/2FtTr79). The Federal Ministry
for the Environment, Nature Conservation and Nuclear Safety (BMU)
supports this initiative on the basis of a decision adopted by the
German Bundestag. The views expressed are the sole responsibility of the
authors and do not necessarily reflect the views of the funders. The
funders are not responsible for any use that may be made of the
information it contains.
