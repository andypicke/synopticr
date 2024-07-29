
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
#>  $ LAST_OBSERVATION  : chr  "2024-07-29T16:00:00Z" "2024-07-29T15:50:00Z" "2024-07-29T15:45:00Z" "2024-07-29T15:45:00Z" ...
#>  $ REPORTING_STATIONS: int  2539 2432 29 190 34 32 6 21 22 26 ...
#>  $ ACTIVE_STATIONS   : int  2631 2504 30 194 34 39 9 23 22 26 ...
#>  $ TOTAL_STATIONS    : int  3549 3595 32 235 38 68 43 65 57 49 ...
#>  $ PERCENT_ACTIVE    : num  74.1 69.7 93.8 82.5 89.5 ...
#>  $ PERCENT_REPORTING : num  96.5 97.1 96.7 97.9 100 ...
#>  $ PERIOD_CHECKED    : int  120 90 30 60 60 120 120 90 120 60 ...
#>  $ ACTIVE_RESTRICTED : int  0 0 0 0 0 0 0 0 0 0 ...
#>  $ TOTAL_RESTRICTED  : int  0 0 0 0 0 0 0 0 0 0 ...
#>  $ PERIOD_OF_RECORD  :'data.frame':  345 obs. of  2 variables:
#>   ..$ start: chr  "1997-01-01T00:00:00Z" "1997-01-01T00:00:00Z" "1997-02-28T00:00:00Z" "1997-01-01T00:00:00Z" ...
#>   ..$ end  : chr  "2024-07-29T16:00:00Z" "2024-07-29T15:50:00Z" "2024-07-29T15:45:00Z" "2024-07-29T15:45:00Z" ...
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
#>   ..$ end  : chr  NA "2024-07-29T15:30:00Z" "2024-07-29T15:30:00Z" NA ...
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
#> tibble [447 × 94] (S3: tbl_df/tbl/data.frame)
#>  $ ID                                       : chr [1:447] "4244" "4308" "4345" "4358" ...
#>  $ STID                                     : chr [1:447] "KACK" "KAQW" "KBAF" "KBED" ...
#>  $ NAME                                     : chr [1:447] "Nantucket, Nantucket Memorial Airport" "North Adams Harriman-and-West Airport" "Westfield, Barnes Municipal Airport" "Laurence G Hanscom Field Airport" ...
#>  $ ELEVATION                                : chr [1:447] "46.0" "640.0" "269.0" "132.0" ...
#>  $ LATITUDE                                 : chr [1:447] "41.25389" "42.69731" "42.15972" "42.46811" ...
#>  $ LONGITUDE                                : chr [1:447] "-70.05972" "-73.16955" "-72.71278" "-71.29463" ...
#>  $ STATUS                                   : chr [1:447] "ACTIVE" "ACTIVE" "ACTIVE" "ACTIVE" ...
#>  $ MNET_ID                                  : chr [1:447] "1" "1" "1" "1" ...
#>  $ STATE                                    : chr [1:447] "MA" "MA" "MA" "MA" ...
#>  $ TIMEZONE                                 : chr [1:447] "America/New_York" "America/New_York" "America/New_York" "America/New_York" ...
#>  $ ELEV_DEM                                 : chr [1:447] "39.4" "646.3" "272.3" "131.2" ...
#>  $ PERIOD_OF_RECORD                         :'data.frame':   447 obs. of  2 variables:
#>   ..$ start: chr [1:447] "2002-08-14T00:00:00Z" "2002-08-14T00:00:00Z" "2002-08-14T00:00:00Z" "2002-08-14T00:00:00Z" ...
#>   ..$ end  : chr [1:447] "2024-07-29T15:30:00Z" "2024-07-29T15:30:00Z" "2024-07-29T15:30:00Z" "2024-07-29T15:30:00Z" ...
#>  $ UNITS                                    :'data.frame':   447 obs. of  2 variables:
#>   ..$ position : chr [1:447] "m" "m" "m" "m" ...
#>   ..$ elevation: chr [1:447] "ft" "ft" "ft" "ft" ...
#>  $ altimeter_value_1                        :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] 101727 101558 101592 101558 101592 ...
#>   ..$ date_time: chr [1:447] "2024-07-29T15:53:00Z" "2024-07-29T15:52:00Z" "2024-07-29T15:53:00Z" "2024-07-29T15:51:00Z" ...
#>  $ air_temp_value_1                         :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] 21.1 21.7 20.6 18.3 19 18.9 20 20.6 20 22.2 ...
#>   ..$ date_time: chr [1:447] "2024-07-29T15:53:00Z" "2024-07-29T15:52:00Z" "2024-07-29T15:53:00Z" "2024-07-29T15:51:00Z" ...
#>  $ relative_humidity_value_1                :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] 90 84.1 92.8 93.3 93.9 ...
#>   ..$ date_time: chr [1:447] "2024-07-29T15:53:00Z" "2024-07-29T15:52:00Z" "2024-07-29T15:53:00Z" "2024-07-29T15:51:00Z" ...
#>  $ wind_speed_value_1                       :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] 6.17 0 2.57 0 2.57 ...
#>   ..$ date_time: chr [1:447] "2024-07-29T15:53:00Z" "2024-07-29T15:52:00Z" "2024-07-29T15:53:00Z" "2024-07-29T15:51:00Z" ...
#>  $ wind_direction_value_1                   :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] 180 0 170 0 180 180 220 210 0 250 ...
#>   ..$ date_time: chr [1:447] "2024-07-29T15:53:00Z" "2024-07-29T15:52:00Z" "2024-07-29T15:53:00Z" "2024-07-29T15:51:00Z" ...
#>  $ wind_gust_value_1                        :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] 8.75 7.72 7.2 8.23 11.83 ...
#>   ..$ date_time: chr [1:447] "2024-07-29T11:30:00Z" "2024-07-26T17:52:00Z" "2024-07-26T19:15:00Z" "2024-07-28T21:40:00Z" ...
#>  $ sea_level_pressure_value_1               :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] 101730 101530 101570 101660 101560 ...
#>   ..$ date_time: chr [1:447] "2024-07-29T15:53:00Z" "2024-07-29T15:52:00Z" "2024-07-29T15:53:00Z" "2024-07-29T15:51:00Z" ...
#>  $ weather_cond_code_value_1                :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] 2493 2493 13 2493 13 ...
#>   ..$ date_time: chr [1:447] "2024-07-29T13:30:00Z" "2024-07-29T15:30:00Z" "2024-07-29T15:25:00Z" "2024-07-29T15:51:00Z" ...
#>  $ cloud_layer_3_code_value_1               :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] 364 604 494 1203 443 ...
#>   ..$ date_time: chr [1:447] "2024-07-29T15:13:00Z" "2024-07-29T15:35:00Z" "2024-07-29T15:10:00Z" "2024-07-29T01:25:00Z" ...
#>  $ pressure_tendency_value_1                :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] 2007 8006 6007 5002 3000 ...
#>   ..$ date_time: chr [1:447] "2024-07-29T14:53:00Z" "2024-07-29T14:52:00Z" "2024-07-29T14:53:00Z" "2024-07-29T14:51:00Z" ...
#>  $ precip_accum_one_hour_value_1            :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] 0.254 0.254 0.254 1.524 0.508 ...
#>   ..$ date_time: chr [1:447] "2024-07-29T14:53:00Z" "2024-07-29T15:52:00Z" "2024-07-29T15:53:00Z" "2024-07-29T15:51:00Z" ...
#>  $ precip_accum_three_hour_value_1          :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] 0.762 0.254 1.524 0.0254 0.254 ...
#>   ..$ date_time: chr [1:447] "2024-07-29T14:53:00Z" "2024-07-29T14:52:00Z" "2024-07-29T14:53:00Z" "2024-07-29T02:51:00Z" ...
#>  $ cloud_layer_1_code_value_1               :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] 313 502 73 93 126 62 62 156 54 364 ...
#>   ..$ date_time: chr [1:447] "2024-07-29T15:53:00Z" "2024-07-29T15:52:00Z" "2024-07-29T15:53:00Z" "2024-07-29T15:51:00Z" ...
#>  $ cloud_layer_2_code_value_1               :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] 434 604 434 274 283 103 113 323 104 344 ...
#>   ..$ date_time: chr [1:447] "2024-07-29T15:53:00Z" "2024-07-29T15:52:00Z" "2024-07-29T15:53:00Z" "2024-07-29T15:51:00Z" ...
#>  $ precip_accum_six_hour_value_1            :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] 6.35 2.54 5.08 0.0254 0.0254 ...
#>   ..$ date_time: chr [1:447] "2024-07-29T11:53:00Z" "2024-07-29T11:52:00Z" "2024-07-29T11:53:00Z" "2024-07-29T05:51:00Z" ...
#>  $ precip_accum_24_hour_value_1             :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] 24.638 2.54 5.334 0.762 0.254 ...
#>   ..$ date_time: chr [1:447] "2024-07-29T11:53:00Z" "2024-07-29T11:52:00Z" "2024-07-29T11:53:00Z" "2024-07-23T11:51:00Z" ...
#>  $ visibility_value_1                       :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] 10 8 10 2 10 3 10 10 2.5 10 ...
#>   ..$ date_time: chr [1:447] "2024-07-29T15:53:00Z" "2024-07-29T15:52:00Z" "2024-07-29T15:53:00Z" "2024-07-29T15:51:00Z" ...
#>  $ metar_value_1                            :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : chr [1:447] "KACK 291553Z 18012KT 10SM BKN031 OVC043 21/19 A3004 RMK AO2 SLP173  T02110194" "KAQW 291552Z AUTO 00000KT 8SM SCT050 OVC060 22/19 A2999 RMK AO2  RAB08E33 SLP153 P0001 T02170189" "KBAF 291553Z 17005KT 10SM BKN007 OVC043 21/19 A3000 RMK AO2 RAE29  CIG 006V010 SLP157 P0001 T02060194" "KBED 291551Z 00000KT 2SM R11/3000VP6000FT -RA BR BKN009 OVC027  18/17 A2999 RMK AO2 RAB02 SLP166 P0006 T01830172" ...
#>   ..$ date_time: chr [1:447] "2024-07-29T15:53:00Z" "2024-07-29T15:52:00Z" "2024-07-29T15:53:00Z" "2024-07-29T15:51:00Z" ...
#>  $ air_temp_high_6_hour_value_1             :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] 18.3 18.9 20.6 19.4 20.6 18.9 19.5 18.3 18.3 20 ...
#>   ..$ date_time: chr [1:447] "2024-07-29T11:53:00Z" "2024-07-29T11:52:00Z" "2024-07-29T11:53:00Z" "2024-07-29T11:51:00Z" ...
#>  $ air_temp_low_6_hour_value_1              :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] 16.7 17.8 17.8 17.2 20 17.8 17.2 16.7 17.8 18.3 ...
#>   ..$ date_time: chr [1:447] "2024-07-29T11:53:00Z" "2024-07-29T11:52:00Z" "2024-07-29T11:53:00Z" "2024-07-29T11:51:00Z" ...
#>  $ peak_wind_speed_value_1                  :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] 13.9 13.9 13.9 18 13.4 ...
#>   ..$ date_time: chr [1:447] "2024-07-29T07:53:00Z" "2024-07-25T21:52:00Z" "2024-07-22T00:53:00Z" "2024-07-17T23:51:00Z" ...
#>  $ ceiling_value_1                          :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] 945 1829 213 274 853 ...
#>   ..$ date_time: chr [1:447] "2024-07-29T15:53:00Z" "2024-07-29T15:52:00Z" "2024-07-29T15:53:00Z" "2024-07-29T15:51:00Z" ...
#>  $ pressure_change_code_value_1             :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] 0 0 0 0 0 0 0 0 0 0 ...
#>   ..$ date_time: chr [1:447] "2024-07-29T00:53:00Z" "2024-07-06T11:00:00Z" "2024-07-17T21:15:00Z" "2024-07-17T01:14:00Z" ...
#>  $ air_temp_high_24_hour_value_1            :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] 22.8 29.4 30.6 30 25 27.8 29.3 25.6 28.9 28.9 ...
#>   ..$ date_time: chr [1:447] "2024-07-29T04:53:00Z" "2024-07-29T04:52:00Z" "2024-07-29T04:53:00Z" "2024-07-29T04:51:00Z" ...
#>  $ air_temp_low_24_hour_value_1             :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] 14.4 12.2 15.6 13.3 16.7 13.3 13.7 16.1 15 14.4 ...
#>   ..$ date_time: chr [1:447] "2024-07-29T04:53:00Z" "2024-07-29T04:52:00Z" "2024-07-29T04:53:00Z" "2024-07-29T04:51:00Z" ...
#>  $ peak_wind_direction_value_1              :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] 290 270 320 290 270 270 340 200 260 260 ...
#>   ..$ date_time: chr [1:447] "2024-07-29T07:53:00Z" "2024-07-25T21:52:00Z" "2024-07-22T00:53:00Z" "2024-07-17T23:51:00Z" ...
#>  $ metar_origin_value_1                     :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] 1 1 1 1 1 1 1 1 1 1 ...
#>   ..$ date_time: chr [1:447] "2024-07-29T15:53:00Z" "2024-07-29T15:52:00Z" "2024-07-29T15:53:00Z" "2024-07-29T15:51:00Z" ...
#>  $ pressure_value_1d                        :'data.frame':   447 obs. of  2 variables:
#>   ..$ date_time: chr [1:447] "2024-07-29T15:53:00Z" "2024-07-29T15:52:00Z" "2024-07-29T15:53:00Z" "2024-07-29T15:51:00Z" ...
#>   ..$ value    : num [1:447] 101558 99230 100607 101074 101518 ...
#>  $ sea_level_pressure_value_1d              :'data.frame':   447 obs. of  2 variables:
#>   ..$ date_time: chr [1:447] "2024-07-29T15:53:00Z" "2024-07-29T15:52:00Z" "2024-07-29T15:53:00Z" "2024-07-29T15:51:00Z" ...
#>   ..$ value    : num [1:447] 101723 101493 101570 101552 101591 ...
#>  $ wet_bulb_temp_value_1d                   :'data.frame':   447 obs. of  2 variables:
#>   ..$ date_time: chr [1:447] "2024-07-29T15:53:00Z" "2024-07-29T15:52:00Z" "2024-07-29T15:53:00Z" "2024-07-29T15:51:00Z" ...
#>   ..$ value    : num [1:447] 20 19.8 19.8 17.6 18.4 ...
#>  $ wind_cardinal_direction_value_1d         :'data.frame':   447 obs. of  2 variables:
#>   ..$ date_time: chr [1:447] "2024-07-29T15:53:00Z" "2024-07-29T15:52:00Z" "2024-07-29T15:53:00Z" "2024-07-29T15:51:00Z" ...
#>   ..$ value    : chr [1:447] "S" "N" "S" "N" ...
#>  $ weather_condition_value_1d               :'data.frame':   447 obs. of  2 variables:
#>   ..$ date_time: chr [1:447] "2024-07-29T13:30:00Z" "2024-07-29T15:30:00Z" "2024-07-29T15:25:00Z" "2024-07-29T15:51:00Z" ...
#>   ..$ value    : chr [1:447] "light rain,mist" "light rain,mist" "light rain" "light rain,mist" ...
#>  $ weather_summary_value_1d                 :'data.frame':   447 obs. of  2 variables:
#>   ..$ date_time: chr [1:447] "2024-07-29T15:53:00Z" "2024-07-29T15:52:00Z" "2024-07-29T15:53:00Z" "2024-07-29T15:51:00Z" ...
#>   ..$ value    : chr [1:447] "overcast" "overcast" "overcast" "light rain,mist" ...
#>  $ cloud_layer_1_value_1d                   :'data.frame':   447 obs. of  2 variables:
#>   ..$ date_time: chr [1:447] "2024-07-29T15:53:00Z" "2024-07-29T15:52:00Z" "2024-07-29T15:53:00Z" "2024-07-29T15:51:00Z" ...
#>   ..$ value    :'data.frame':    447 obs. of  2 variables:
#>   .. ..$ sky_condition: chr [1:447] "broken" "scattered" "broken" "broken" ...
#>   .. ..$ height_agl   : num [1:447] 945 1524 213 274 366 ...
#>  $ cloud_layer_2_value_1d                   :'data.frame':   447 obs. of  2 variables:
#>   ..$ date_time: chr [1:447] "2024-07-29T15:53:00Z" "2024-07-29T15:52:00Z" "2024-07-29T15:53:00Z" "2024-07-29T15:51:00Z" ...
#>   ..$ value    :'data.frame':    447 obs. of  2 variables:
#>   .. ..$ sky_condition: chr [1:447] "overcast" "overcast" "overcast" "overcast" ...
#>   .. ..$ height_agl   : num [1:447] 1311 1829 1311 823 853 ...
#>  $ cloud_layer_3_value_1d                   :'data.frame':   447 obs. of  2 variables:
#>   ..$ date_time: chr [1:447] "2024-07-29T15:13:00Z" "2024-07-29T15:35:00Z" "2024-07-29T15:10:00Z" "2024-07-29T01:25:00Z" ...
#>   ..$ value    :'data.frame':    447 obs. of  2 variables:
#>   .. ..$ sky_condition: chr [1:447] "overcast" "overcast" "overcast" "broken" ...
#>   .. ..$ height_agl   : num [1:447] 1097 1829 1494 3658 1341 ...
#>  $ dew_point_temperature_value_1d           :'data.frame':   447 obs. of  2 variables:
#>   ..$ date_time: chr [1:447] "2024-07-29T15:53:00Z" "2024-07-29T15:52:00Z" "2024-07-29T15:53:00Z" "2024-07-29T15:51:00Z" ...
#>   ..$ value    : num [1:447] 19.4 18.9 19.4 17.2 18 ...
#>  $ dew_point_temperature_value_1            :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] NA NA NA NA NA NA 18 NA NA NA ...
#>   ..$ date_time: chr [1:447] NA NA NA NA ...
#>  $ snow_depth_value_1                       :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] NA NA NA NA NA NA 25.4 NA NA NA ...
#>   ..$ date_time: chr [1:447] NA NA NA NA ...
#>  $ precip_accum_since_local_midnight_value_1:'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] NA NA NA NA NA NA NA NA NA NA ...
#>   ..$ date_time: chr [1:447] NA NA NA NA ...
#>  $ solar_radiation_value_1                  :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] NA NA NA NA NA NA NA NA NA NA ...
#>   ..$ date_time: chr [1:447] NA NA NA NA ...
#>  $ heat_index_value_1d                      :'data.frame':   447 obs. of  2 variables:
#>   ..$ date_time: chr [1:447] NA NA NA NA ...
#>   ..$ value    : num [1:447] NA NA NA NA NA NA NA NA NA NA ...
#>  $ precip_accum_value_1                     :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] NA NA NA NA NA NA NA NA NA NA ...
#>   ..$ date_time: chr [1:447] NA NA NA NA ...
#>  $ fuel_temp_value_1                        :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] NA NA NA NA NA NA NA NA NA NA ...
#>   ..$ date_time: chr [1:447] NA NA NA NA ...
#>  $ fuel_moisture_value_1                    :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] NA NA NA NA NA NA NA NA NA NA ...
#>   ..$ date_time: chr [1:447] NA NA NA NA ...
#>  $ volt_value_1                             :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] NA NA NA NA NA NA NA NA NA NA ...
#>   ..$ date_time: chr [1:447] NA NA NA NA ...
#>  $ pressure_value_1                         :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] NA NA NA NA NA NA NA NA NA NA ...
#>   ..$ date_time: chr [1:447] NA NA NA NA ...
#>  $ T_water_temp_value_1                     :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] NA NA NA NA NA NA NA NA NA NA ...
#>   ..$ date_time: chr [1:447] NA NA NA NA ...
#>  $ primary_swell_true_direction_value_1     :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] NA NA NA NA NA NA NA NA NA NA ...
#>   ..$ date_time: chr [1:447] NA NA NA NA ...
#>  $ primary_swell_wave_period_value_1        :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] NA NA NA NA NA NA NA NA NA NA ...
#>   ..$ date_time: chr [1:447] NA NA NA NA ...
#>  $ primary_swell_wave_height_value_1        :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] NA NA NA NA NA NA NA NA NA NA ...
#>   ..$ date_time: chr [1:447] NA NA NA NA ...
#>  $ wave_period_value_1                      :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] NA NA NA NA NA NA NA NA NA NA ...
#>   ..$ date_time: chr [1:447] NA NA NA NA ...
#>  $ wave_height_value_1                      :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] NA NA NA NA NA NA NA NA NA NA ...
#>   ..$ date_time: chr [1:447] NA NA NA NA ...
#>  $ altimeter_value_1d                       :'data.frame':   447 obs. of  2 variables:
#>   ..$ date_time: chr [1:447] NA NA NA NA ...
#>   ..$ value    : num [1:447] NA NA NA NA NA NA NA NA NA NA ...
#>  $ water_temp_value_1                       :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] NA NA NA NA NA NA NA NA NA NA ...
#>   ..$ date_time: chr [1:447] NA NA NA NA ...
#>  $ mean_tide_level_value_1                  :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] NA NA NA NA NA NA NA NA NA NA ...
#>   ..$ date_time: chr [1:447] NA NA NA NA ...
#>  $ mean_sea_level_value_1                   :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] NA NA NA NA NA NA NA NA NA NA ...
#>   ..$ date_time: chr [1:447] NA NA NA NA ...
#>  $ mean_lower_low_water_value_1             :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] NA NA NA NA NA NA NA NA NA NA ...
#>   ..$ date_time: chr [1:447] NA NA NA NA ...
#>  $ mean_low_water_value_1                   :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] NA NA NA NA NA NA NA NA NA NA ...
#>   ..$ date_time: chr [1:447] NA NA NA NA ...
#>  $ mean_high_water_value_1                  :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] NA NA NA NA NA NA NA NA NA NA ...
#>   ..$ date_time: chr [1:447] NA NA NA NA ...
#>  $ mean_higher_high_water_value_1           :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] NA NA NA NA NA NA NA NA NA NA ...
#>   ..$ date_time: chr [1:447] NA NA NA NA ...
#>  $ ozone_concentration_value_1              :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] NA NA NA NA NA NA NA NA NA NA ...
#>   ..$ date_time: chr [1:447] NA NA NA NA ...
#>  $ PM_25_concentration_value_1              :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] NA NA NA NA NA NA NA NA NA NA ...
#>   ..$ date_time: chr [1:447] NA NA NA NA ...
#>  $ NO2_concentration_value_1                :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] NA NA NA NA NA NA NA NA NA NA ...
#>   ..$ date_time: chr [1:447] NA NA NA NA ...
#>  $ NO_concentration_value_1                 :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] NA NA NA NA NA NA NA NA NA NA ...
#>   ..$ date_time: chr [1:447] NA NA NA NA ...
#>  $ NOx_concentration_value_1                :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] NA NA NA NA NA NA NA NA NA NA ...
#>   ..$ date_time: chr [1:447] NA NA NA NA ...
#>  $ NOy_concentration_value_1                :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] NA NA NA NA NA NA NA NA NA NA ...
#>   ..$ date_time: chr [1:447] NA NA NA NA ...
#>  $ PM_10_concentration_value_1              :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] NA NA NA NA NA NA NA NA NA NA ...
#>   ..$ date_time: chr [1:447] NA NA NA NA ...
#>  $ SO2_concentration_value_1                :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] NA NA NA NA NA NA NA NA NA NA ...
#>   ..$ date_time: chr [1:447] NA NA NA NA ...
#>  $ CO_concentration_value_1                 :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] NA NA NA NA NA NA NA NA NA NA ...
#>   ..$ date_time: chr [1:447] NA NA NA NA ...
#>  $ road_temp_value_1                        :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] NA NA NA NA NA NA NA NA NA NA ...
#>   ..$ date_time: chr [1:447] NA NA NA NA ...
#>  $ road_surface_condition_value_1           :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] NA NA NA NA NA NA NA NA NA NA ...
#>   ..$ date_time: chr [1:447] NA NA NA NA ...
#>  $ road_freezing_temp_value_1               :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] NA NA NA NA NA NA NA NA NA NA ...
#>   ..$ date_time: chr [1:447] NA NA NA NA ...
#>  $ wind_chill_value_1d                      :'data.frame':   447 obs. of  2 variables:
#>   ..$ date_time: chr [1:447] NA NA NA NA ...
#>   ..$ value    : num [1:447] NA NA NA NA NA NA NA NA NA NA ...
#>  $ precip_accum_fifteen_minute_value_1      :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] NA NA NA NA NA NA NA NA NA NA ...
#>   ..$ date_time: chr [1:447] NA NA NA NA ...
#>  $ snow_accum_24_hour_value_1               :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] NA NA NA NA NA NA NA NA NA NA ...
#>   ..$ date_time: chr [1:447] NA NA NA NA ...
#>  $ water_current_speed_value_1              :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] NA NA NA NA NA NA NA NA NA NA ...
#>   ..$ date_time: chr [1:447] NA NA NA NA ...
#>  $ water_current_direction_value_1          :'data.frame':   447 obs. of  2 variables:
#>   ..$ value    : num [1:447] NA NA NA NA NA NA NA NA NA NA ...
#>   ..$ date_time: chr [1:447] NA NA NA NA ...
#>  $ SENSOR_VARIABLES                         :'data.frame':   447 obs. of  75 variables:
#>   ..$ altimeter                        :'data.frame':    447 obs. of  2 variables:
#>   .. ..$ altimeter_value_1 :'data.frame':    447 obs. of  0 variables
#>   .. ..$ altimeter_value_1d:'data.frame':    447 obs. of  1 variable:
#>   .. .. ..$ derived_from:List of 447
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr "pressure_value_1"
#>   .. .. .. ..$ : chr "pressure_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr "pressure_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. .. [list output truncated]
#>   ..$ air_temp                         :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ air_temp_value_1:'data.frame':  447 obs. of  0 variables
#>   ..$ relative_humidity                :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ relative_humidity_value_1:'data.frame': 447 obs. of  0 variables
#>   ..$ wind_speed                       :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ wind_speed_value_1:'data.frame':    447 obs. of  0 variables
#>   ..$ wind_direction                   :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ wind_direction_value_1:'data.frame':    447 obs. of  0 variables
#>   ..$ wind_gust                        :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ wind_gust_value_1:'data.frame': 447 obs. of  0 variables
#>   ..$ sea_level_pressure               :'data.frame':    447 obs. of  2 variables:
#>   .. ..$ sea_level_pressure_value_1 :'data.frame':   447 obs. of  0 variables
#>   .. ..$ sea_level_pressure_value_1d:'data.frame':   447 obs. of  1 variable:
#>   .. .. ..$ derived_from:List of 447
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. .. [list output truncated]
#>   ..$ weather_cond_code                :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ weather_cond_code_value_1:'data.frame': 447 obs. of  0 variables
#>   ..$ cloud_layer_3_code               :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ cloud_layer_3_code_value_1:'data.frame':    447 obs. of  0 variables
#>   ..$ pressure_tendency                :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ pressure_tendency_value_1:'data.frame': 447 obs. of  0 variables
#>   ..$ precip_accum_one_hour            :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ precip_accum_one_hour_value_1:'data.frame': 447 obs. of  0 variables
#>   ..$ precip_accum_three_hour          :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ precip_accum_three_hour_value_1:'data.frame':   447 obs. of  0 variables
#>   ..$ cloud_layer_1_code               :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ cloud_layer_1_code_value_1:'data.frame':    447 obs. of  0 variables
#>   ..$ cloud_layer_2_code               :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ cloud_layer_2_code_value_1:'data.frame':    447 obs. of  0 variables
#>   ..$ precip_accum_six_hour            :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ precip_accum_six_hour_value_1:'data.frame': 447 obs. of  0 variables
#>   ..$ precip_accum_24_hour             :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ precip_accum_24_hour_value_1:'data.frame':  447 obs. of  0 variables
#>   ..$ visibility                       :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ visibility_value_1:'data.frame':    447 obs. of  0 variables
#>   ..$ metar                            :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ metar_value_1:'data.frame': 447 obs. of  0 variables
#>   ..$ air_temp_high_6_hour             :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ air_temp_high_6_hour_value_1:'data.frame':  447 obs. of  0 variables
#>   ..$ air_temp_low_6_hour              :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ air_temp_low_6_hour_value_1:'data.frame':   447 obs. of  0 variables
#>   ..$ peak_wind_speed                  :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ peak_wind_speed_value_1:'data.frame':   447 obs. of  0 variables
#>   ..$ ceiling                          :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ ceiling_value_1:'data.frame':   447 obs. of  0 variables
#>   ..$ pressure_change_code             :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ pressure_change_code_value_1:'data.frame':  447 obs. of  0 variables
#>   ..$ air_temp_high_24_hour            :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ air_temp_high_24_hour_value_1:'data.frame': 447 obs. of  0 variables
#>   ..$ air_temp_low_24_hour             :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ air_temp_low_24_hour_value_1:'data.frame':  447 obs. of  0 variables
#>   ..$ peak_wind_direction              :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ peak_wind_direction_value_1:'data.frame':   447 obs. of  0 variables
#>   ..$ metar_origin                     :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ metar_origin_value_1:'data.frame':  447 obs. of  0 variables
#>   ..$ pressure                         :'data.frame':    447 obs. of  2 variables:
#>   .. ..$ pressure_value_1d:'data.frame': 447 obs. of  1 variable:
#>   .. .. ..$ derived_from:List of 447
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. ..$ : chr "altimeter_value_1"
#>   .. .. .. .. [list output truncated]
#>   .. ..$ pressure_value_1 :'data.frame': 447 obs. of  0 variables
#>   ..$ wet_bulb_temp                    :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ wet_bulb_temp_value_1d:'data.frame':    447 obs. of  1 variable:
#>   .. .. ..$ derived_from:List of 447
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:3] "pressure_value_1d" "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. .. [list output truncated]
#>   ..$ wind_cardinal_direction          :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ wind_cardinal_direction_value_1d:'data.frame':  447 obs. of  1 variable:
#>   .. .. ..$ derived_from:List of 447
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. ..$ : chr "wind_direction_value_1"
#>   .. .. .. .. [list output truncated]
#>   ..$ weather_condition                :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ weather_condition_value_1d:'data.frame':    447 obs. of  1 variable:
#>   .. .. ..$ derived_from:List of 447
#>   .. .. .. ..$ : chr "weather_cond_code_value_1"
#>   .. .. .. ..$ : chr "weather_cond_code_value_1"
#>   .. .. .. ..$ : chr "weather_cond_code_value_1"
#>   .. .. .. ..$ : chr "weather_cond_code_value_1"
#>   .. .. .. ..$ : chr "weather_cond_code_value_1"
#>   .. .. .. ..$ : chr "weather_cond_code_value_1"
#>   .. .. .. ..$ : chr "weather_cond_code_value_1"
#>   .. .. .. ..$ : chr "weather_cond_code_value_1"
#>   .. .. .. ..$ : chr "weather_cond_code_value_1"
#>   .. .. .. ..$ : chr "weather_cond_code_value_1"
#>   .. .. .. ..$ : chr "weather_cond_code_value_1"
#>   .. .. .. ..$ : chr "weather_cond_code_value_1"
#>   .. .. .. ..$ : chr "weather_cond_code_value_1"
#>   .. .. .. ..$ : chr "weather_cond_code_value_1"
#>   .. .. .. ..$ : chr "weather_cond_code_value_1"
#>   .. .. .. ..$ : chr "weather_cond_code_value_1"
#>   .. .. .. ..$ : chr "weather_cond_code_value_1"
#>   .. .. .. ..$ : chr "weather_cond_code_value_1"
#>   .. .. .. ..$ : chr "weather_cond_code_value_1"
#>   .. .. .. ..$ : chr "weather_cond_code_value_1"
#>   .. .. .. ..$ : chr "weather_cond_code_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr "weather_cond_code_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. .. [list output truncated]
#>   ..$ weather_summary                  :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ weather_summary_value_1d:'data.frame':  447 obs. of  1 variable:
#>   .. .. ..$ derived_from:List of 447
#>   .. .. .. ..$ : chr [1:4] "weather_cond_code_value_1" "cloud_layer_3_code_value_1" "cloud_layer_2_code_value_1" "cloud_layer_1_code_value_1"
#>   .. .. .. ..$ : chr [1:4] "weather_cond_code_value_1" "cloud_layer_3_code_value_1" "cloud_layer_2_code_value_1" "cloud_layer_1_code_value_1"
#>   .. .. .. ..$ : chr [1:4] "weather_cond_code_value_1" "cloud_layer_3_code_value_1" "cloud_layer_2_code_value_1" "cloud_layer_1_code_value_1"
#>   .. .. .. ..$ : chr [1:4] "weather_cond_code_value_1" "cloud_layer_3_code_value_1" "cloud_layer_2_code_value_1" "cloud_layer_1_code_value_1"
#>   .. .. .. ..$ : chr [1:4] "weather_cond_code_value_1" "cloud_layer_3_code_value_1" "cloud_layer_2_code_value_1" "cloud_layer_1_code_value_1"
#>   .. .. .. ..$ : chr [1:4] "weather_cond_code_value_1" "cloud_layer_3_code_value_1" "cloud_layer_2_code_value_1" "cloud_layer_1_code_value_1"
#>   .. .. .. ..$ : chr [1:4] "weather_cond_code_value_1" "cloud_layer_3_code_value_1" "cloud_layer_2_code_value_1" "cloud_layer_1_code_value_1"
#>   .. .. .. ..$ : chr [1:4] "weather_cond_code_value_1" "cloud_layer_3_code_value_1" "cloud_layer_2_code_value_1" "cloud_layer_1_code_value_1"
#>   .. .. .. ..$ : chr [1:4] "weather_cond_code_value_1" "cloud_layer_3_code_value_1" "cloud_layer_2_code_value_1" "cloud_layer_1_code_value_1"
#>   .. .. .. ..$ : chr [1:4] "weather_cond_code_value_1" "cloud_layer_3_code_value_1" "cloud_layer_2_code_value_1" "cloud_layer_1_code_value_1"
#>   .. .. .. ..$ : chr [1:4] "weather_cond_code_value_1" "cloud_layer_3_code_value_1" "cloud_layer_2_code_value_1" "cloud_layer_1_code_value_1"
#>   .. .. .. ..$ : chr [1:4] "weather_cond_code_value_1" "cloud_layer_3_code_value_1" "cloud_layer_2_code_value_1" "cloud_layer_1_code_value_1"
#>   .. .. .. ..$ : chr [1:4] "weather_cond_code_value_1" "cloud_layer_3_code_value_1" "cloud_layer_2_code_value_1" "cloud_layer_1_code_value_1"
#>   .. .. .. ..$ : chr [1:4] "weather_cond_code_value_1" "cloud_layer_3_code_value_1" "cloud_layer_2_code_value_1" "cloud_layer_1_code_value_1"
#>   .. .. .. ..$ : chr [1:4] "weather_cond_code_value_1" "cloud_layer_3_code_value_1" "cloud_layer_2_code_value_1" "cloud_layer_1_code_value_1"
#>   .. .. .. ..$ : chr [1:4] "weather_cond_code_value_1" "cloud_layer_3_code_value_1" "cloud_layer_2_code_value_1" "cloud_layer_1_code_value_1"
#>   .. .. .. ..$ : chr [1:4] "weather_cond_code_value_1" "cloud_layer_3_code_value_1" "cloud_layer_2_code_value_1" "cloud_layer_1_code_value_1"
#>   .. .. .. ..$ : chr [1:4] "weather_cond_code_value_1" "cloud_layer_3_code_value_1" "cloud_layer_2_code_value_1" "cloud_layer_1_code_value_1"
#>   .. .. .. ..$ : chr [1:4] "weather_cond_code_value_1" "cloud_layer_3_code_value_1" "cloud_layer_2_code_value_1" "cloud_layer_1_code_value_1"
#>   .. .. .. ..$ : chr [1:4] "weather_cond_code_value_1" "cloud_layer_3_code_value_1" "cloud_layer_2_code_value_1" "cloud_layer_1_code_value_1"
#>   .. .. .. ..$ : chr [1:4] "weather_cond_code_value_1" "cloud_layer_3_code_value_1" "cloud_layer_2_code_value_1" "cloud_layer_1_code_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr [1:4] "weather_cond_code_value_1" "cloud_layer_3_code_value_1" "cloud_layer_2_code_value_1" "cloud_layer_1_code_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. .. [list output truncated]
#>   ..$ cloud_layer_1                    :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ cloud_layer_1_value_1d:'data.frame':    447 obs. of  1 variable:
#>   .. .. ..$ derived_from:List of 447
#>   .. .. .. ..$ : chr "cloud_layer_1_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_1_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_1_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_1_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_1_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_1_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_1_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_1_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_1_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_1_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_1_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_1_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_1_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_1_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_1_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_1_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_1_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_1_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_1_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_1_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_1_code_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr "cloud_layer_1_code_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. .. [list output truncated]
#>   ..$ cloud_layer_2                    :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ cloud_layer_2_value_1d:'data.frame':    447 obs. of  1 variable:
#>   .. .. ..$ derived_from:List of 447
#>   .. .. .. ..$ : chr "cloud_layer_2_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_2_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_2_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_2_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_2_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_2_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_2_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_2_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_2_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_2_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_2_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_2_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_2_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_2_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_2_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_2_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_2_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_2_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_2_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_2_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_2_code_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr "cloud_layer_2_code_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. .. [list output truncated]
#>   ..$ cloud_layer_3                    :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ cloud_layer_3_value_1d:'data.frame':    447 obs. of  1 variable:
#>   .. .. ..$ derived_from:List of 447
#>   .. .. .. ..$ : chr "cloud_layer_3_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_3_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_3_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_3_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_3_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_3_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_3_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_3_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_3_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_3_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_3_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_3_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_3_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_3_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_3_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_3_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_3_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_3_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_3_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_3_code_value_1"
#>   .. .. .. ..$ : chr "cloud_layer_3_code_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr "cloud_layer_3_code_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. .. [list output truncated]
#>   ..$ wind_chill                       :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ wind_chill_value_1d:'data.frame':   447 obs. of  1 variable:
#>   .. .. ..$ derived_from:List of 447
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "wind_speed_value_1"
#>   .. .. .. .. [list output truncated]
#>   ..$ dew_point_temperature            :'data.frame':    447 obs. of  2 variables:
#>   .. ..$ dew_point_temperature_value_1d:'data.frame':    447 obs. of  1 variable:
#>   .. .. ..$ derived_from:List of 447
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. .. [list output truncated]
#>   .. ..$ dew_point_temperature_value_1 :'data.frame':    447 obs. of  0 variables
#>   ..$ heat_index                       :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ heat_index_value_1d:'data.frame':   447 obs. of  1 variable:
#>   .. .. ..$ derived_from:List of 447
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : NULL
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. ..$ : chr [1:2] "air_temp_value_1" "relative_humidity_value_1"
#>   .. .. .. .. [list output truncated]
#>   ..$ snow_depth                       :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ snow_depth_value_1:'data.frame':    447 obs. of  0 variables
#>   ..$ precip_accum_since_local_midnight:'data.frame':    447 obs. of  1 variable:
#>   .. ..$ precip_accum_since_local_midnight_value_1:'data.frame': 447 obs. of  0 variables
#>   ..$ solar_radiation                  :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ solar_radiation_value_1:'data.frame':   447 obs. of  0 variables
#>   ..$ precip_accum                     :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ precip_accum_value_1:'data.frame':  447 obs. of  0 variables
#>   ..$ fuel_temp                        :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ fuel_temp_value_1:'data.frame': 447 obs. of  0 variables
#>   ..$ fuel_moisture                    :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ fuel_moisture_value_1:'data.frame': 447 obs. of  0 variables
#>   ..$ volt                             :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ volt_value_1:'data.frame':  447 obs. of  0 variables
#>   ..$ T_water_temp                     :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ T_water_temp_value_1:'data.frame':  447 obs. of  0 variables
#>   ..$ primary_swell_true_direction     :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ primary_swell_true_direction_value_1:'data.frame':  447 obs. of  0 variables
#>   ..$ primary_swell_wave_period        :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ primary_swell_wave_period_value_1:'data.frame': 447 obs. of  0 variables
#>   ..$ primary_swell_wave_height        :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ primary_swell_wave_height_value_1:'data.frame': 447 obs. of  0 variables
#>   ..$ wave_period                      :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ wave_period_value_1:'data.frame':   447 obs. of  0 variables
#>   ..$ wave_height                      :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ wave_height_value_1:'data.frame':   447 obs. of  0 variables
#>   ..$ water_temp                       :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ water_temp_value_1:'data.frame':    447 obs. of  0 variables
#>   ..$ mean_tide_level                  :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ mean_tide_level_value_1:'data.frame':   447 obs. of  0 variables
#>   ..$ mean_sea_level                   :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ mean_sea_level_value_1:'data.frame':    447 obs. of  0 variables
#>   ..$ mean_lower_low_water             :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ mean_lower_low_water_value_1:'data.frame':  447 obs. of  0 variables
#>   ..$ mean_low_water                   :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ mean_low_water_value_1:'data.frame':    447 obs. of  0 variables
#>   ..$ mean_high_water                  :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ mean_high_water_value_1:'data.frame':   447 obs. of  0 variables
#>   ..$ mean_higher_high_water           :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ mean_higher_high_water_value_1:'data.frame':    447 obs. of  0 variables
#>   ..$ ozone_concentration              :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ ozone_concentration_value_1:'data.frame':   447 obs. of  0 variables
#>   ..$ PM_25_concentration              :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ PM_25_concentration_value_1:'data.frame':   447 obs. of  0 variables
#>   ..$ NO2_concentration                :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ NO2_concentration_value_1:'data.frame': 447 obs. of  0 variables
#>   ..$ NO_concentration                 :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ NO_concentration_value_1:'data.frame':  447 obs. of  0 variables
#>   ..$ NOx_concentration                :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ NOx_concentration_value_1:'data.frame': 447 obs. of  0 variables
#>   ..$ NOy_concentration                :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ NOy_concentration_value_1:'data.frame': 447 obs. of  0 variables
#>   ..$ PM_10_concentration              :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ PM_10_concentration_value_1:'data.frame':   447 obs. of  0 variables
#>   ..$ SO2_concentration                :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ SO2_concentration_value_1:'data.frame': 447 obs. of  0 variables
#>   ..$ CO_concentration                 :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ CO_concentration_value_1:'data.frame':  447 obs. of  0 variables
#>   ..$ road_temp                        :'data.frame':    447 obs. of  4 variables:
#>   .. ..$ road_temp_value_1:'data.frame': 447 obs. of  0 variables
#>   .. ..$ road_temp_value_2:'data.frame': 447 obs. of  0 variables
#>   .. ..$ road_temp_value_3:'data.frame': 447 obs. of  0 variables
#>   .. ..$ road_temp_value_4:'data.frame': 447 obs. of  0 variables
#>   ..$ road_freezing_temp               :'data.frame':    447 obs. of  3 variables:
#>   .. ..$ road_freezing_temp_value_2:'data.frame':    447 obs. of  0 variables
#>   .. ..$ road_freezing_temp_value_1:'data.frame':    447 obs. of  0 variables
#>   .. ..$ road_freezing_temp_value_3:'data.frame':    447 obs. of  0 variables
#>   ..$ road_subsurface_tmp              :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ road_subsurface_tmp_value_1:'data.frame':   447 obs. of  0 variables
#>   ..$ road_surface_condition           :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ road_surface_condition_value_1:'data.frame':    447 obs. of  0 variables
#>   ..$ precip_accum_fifteen_minute      :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ precip_accum_fifteen_minute_value_1:'data.frame':   447 obs. of  0 variables
#>   ..$ snow_accum_24_hour               :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ snow_accum_24_hour_value_1:'data.frame':    447 obs. of  0 variables
#>   ..$ water_current_speed              :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ water_current_speed_value_1:'data.frame':   447 obs. of  0 variables
#>   ..$ water_current_direction          :'data.frame':    447 obs. of  1 variable:
#>   .. ..$ water_current_direction_value_1:'data.frame':   447 obs. of  0 variables
#>  $ QC_FLAGGED                               : logi [1:447] FALSE FALSE FALSE FALSE FALSE FALSE ...
#>  $ RESTRICTED                               : logi [1:447] FALSE FALSE FALSE FALSE FALSE FALSE ...
```
