
<!-- README.md is generated from README.Rmd. Please edit that file -->

# synopticr

<!-- badges: start -->

[![R-CMD-check](https://github.com/andypicke/synopticr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/andypicke/synopticr/actions/workflows/R-CMD-check.yaml)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

<!-- badges: end -->

The goal of {synopticr} is to make it easy to retrieve weather data from
the [Synoptic Data](https://synopticdata.com/) [weather
API](https://synopticdata.com/weatherapi/) via R.

## Installation

You can install the development version of {synopticr} from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("andypicke/synopticr")
```

## Authentication

You will need to [sign up for an api
token](https://signin.synopticdata.com/u/signup/) before using the api.
Synoptic offers free
[open-access](https://synopticdata.com/pricing/open-access-pricing/) for
non-commercial users. The functions in {synopticr} assume by default
that your token is stored in your *.Renviron* file as
SYNOPTIC_API_KEY=“you_key_here”. You can also pass in your api token
explicitly if wanted.

<div class="callout-note">

To store your api key, I find the easiest way is to use the
*edit_r_environ()* function from the {usethis} package.

</div>

# Examples

### Get networks

The *get_networks()* function returns a dataframe of all the weather
station networks available through the Synoptic api.

``` r

library(synopticr)

networks <- get_networks()

str(networks)
#> 'data.frame':    345 obs. of  15 variables:
#>  $ ID                : chr  "1" "2" "3" "4" ...
#>  $ SHORTNAME         : chr  "ASOS/AWOS" "RAWS" "DUGWAY" "UTAH DOT" ...
#>  $ LONGNAME          : chr  "ASOS/AWOS" "Interagency Remote Automatic Weather Stations" "U.S. Army Dugway Proving Grounds" "Utah Department of Transportation" ...
#>  $ URL               : chr  NA NA NA NA ...
#>  $ CATEGORY          : chr  "4" "9" "4" "10" ...
#>  $ LAST_OBSERVATION  : chr  "2024-07-29T16:35:00Z" "2024-07-29T16:35:00Z" "2024-07-29T16:25:00Z" "2024-07-29T16:25:00Z" ...
#>  $ REPORTING_STATIONS: int  2545 2437 29 189 34 38 6 21 22 26 ...
#>  $ ACTIVE_STATIONS   : int  2631 2504 30 194 34 39 9 23 22 26 ...
#>  $ TOTAL_STATIONS    : int  3549 3595 32 235 38 68 43 65 57 49 ...
#>  $ PERCENT_ACTIVE    : num  74.1 69.7 93.8 82.5 89.5 ...
#>  $ PERCENT_REPORTING : num  96.7 97.3 96.7 97.4 100 ...
#>  $ PERIOD_CHECKED    : int  120 90 30 60 60 120 120 90 120 60 ...
#>  $ ACTIVE_RESTRICTED : int  0 0 0 0 0 0 0 0 0 0 ...
#>  $ TOTAL_RESTRICTED  : int  0 0 0 0 0 0 0 0 0 0 ...
#>  $ PERIOD_OF_RECORD  :'data.frame':  345 obs. of  2 variables:
#>   ..$ start: chr  "1997-01-01T00:00:00Z" "1997-01-01T00:00:00Z" "1997-02-28T00:00:00Z" "1997-01-01T00:00:00Z" ...
#>   ..$ end  : chr  "2024-07-29T16:35:00Z" "2024-07-29T16:35:00Z" "2024-07-29T16:25:00Z" "2024-07-29T16:25:00Z" ...
```

### Get station metadata

The *get_metadata()* function will return a dataframe of stations and
their metadata for a specified state.

- Note the *STID* for each station can be used in other functions to
  request data for a specific station.

``` r


meta <- get_metadata(wh_state = "MA")

#head(meta)
str(meta)
#> 'data.frame':    875 obs. of  14 variables:
#>  $ ID              : chr  "4168" "4244" "4308" "4340" ...
#>  $ STID            : chr  "K2B6" "KACK" "KAQW" "KAYE" ...
#>  $ NAME            : chr  "NORTH ADAMS" "Nantucket, Nantucket Memorial Airport" "North Adams Harriman-and-West Airport" "Fort Devens / Ayer" ...
#>  $ ELEVATION       : chr  "659.0" "46.0" "640.0" "269.0" ...
#>  $ LATITUDE        : chr  "42.7" "41.25389" "42.69731" "42.56667" ...
#>  $ LONGITUDE       : chr  "-73.17" "-70.05972" "-73.16955" "-71.6" ...
#>  $ STATUS          : chr  "INACTIVE" "ACTIVE" "ACTIVE" "INACTIVE" ...
#>  $ MNET_ID         : chr  "1" "1" "1" "1" ...
#>  $ STATE           : chr  "MA" "MA" "MA" "MA" ...
#>  $ TIMEZONE        : chr  "America/New_York" "America/New_York" "America/New_York" "America/New_York" ...
#>  $ ELEV_DEM        : chr  "639.8" "39.4" "646.3" "265.7" ...
#>  $ PERIOD_OF_RECORD:'data.frame':    875 obs. of  2 variables:
#>   ..$ start: chr  NA "2002-08-14T00:00:00Z" "2002-08-14T00:00:00Z" NA ...
#>   ..$ end  : chr  NA "2024-07-29T15:55:00Z" "2024-07-29T15:52:00Z" NA ...
#>  $ UNITS           :'data.frame':    875 obs. of  2 variables:
#>   ..$ position : chr  "m" "m" "m" "m" ...
#>   ..$ elevation: chr  "ft" "ft" "ft" "ft" ...
#>  $ RESTRICTED      : logi  FALSE FALSE FALSE FALSE FALSE FALSE ...
```

### Get latest data *In Progress*

*get_latest_data()* returns the latest available data for stations in 1
state.

- Each row in the returned dataframe corresponds to a single station.

- *I am currently working on improving this function to clean up
  variable names and allow for more options (requesting data for single
  stations etc.)*

``` r

df <- get_latest_data(wh_state = "MA")

library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union

str(df)
#>  POSIXct[1:447], format: "2024-07-29 16:25:00" "2024-07-29 16:25:00" "2024-07-29 16:25:00" ...
```
