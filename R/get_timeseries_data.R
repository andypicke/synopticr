#' Get timeseries data for a weather station
#'
#' @param start_time Starting time in YYYYmmddHHMM format.
#' @param end_time End time in YYYYmmddHHMM format
#' @param units c("english", "metric") - Default "english"
#' @param wh_station Station id
#' @param token Default is Sys.getenv("SYNOPTIC_API_KEY")
#'
#' @return Dataframe of timeseries data
#' @export
#'
get_timeseries_data <- function(start_time = "202407100000",
                                end_time = "202407150000",
                                units = c("english", "metric"),
                                wh_station = "KDEN",
                                token = Sys.getenv("SYNOPTIC_API_KEY")){

  units <- match.arg(units)

  base_url <- "https://api.synopticdata.com/v2/"

  endpoint <- "stations/timeseries"

  req_url <- paste0(base_url, endpoint, "?token=", token, "&stid=", wh_station,
                    "&start=", start_time, "&end=", end_time,
                    "&units=", units)

  # Send the API request and get response
  resp_parsed <- execute_api_request(req_url)

  # the data we want is the "STATION" variable in the list
  df <- resp_parsed$STATION

  # each row in df corresponds to one station
  # each station/row contains a dataframe with the observations
  obs_names <- names(df$OBSERVATIONS)
  df2 <- tidyr::unnest(df,'OBSERVATIONS') # unpack the OBSERVATIONS data frame

  # the OBSERVATIONS dataframe contains a data frame for each measurement; unpack again
  df4 <- tidyr::unnest(df2, tidyselect::all_of(obs_names), names_sep = "_")

  df4$date_time <- lubridate::as_datetime(df4$date_time)
  #df4$air_temp_value_1_date_time <- lubridate::as_datetime(df4$air_temp_value_1_date_time)

  return(df4)

}
