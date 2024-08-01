#' Get latest data from weather stations
#'
#' @param wh_station Station to get data for.
#' @param wh_state State (abbreviated) to get data for. Default NULL. If specified will get data for all stations in state.
#' @param units c("english", "metric") - Default "english"
#' @param token token (api key). Default is Sys.getenv("SYNOPTIC_API_KEY")
#'
#' @return Dataframe of latest data for requested stations
#' @export
get_latest_data <- function(wh_station = "KDEN",
                            wh_state = NULL,
                            units = c("english", "metric"),
                            token = Sys.getenv("SYNOPTIC_API_KEY")){

  units <- match.arg(units)

  base_url <- "https://api.synopticdata.com/v2/"

  endpoint <- "stations/latest"

  if (is.null(wh_state)) {
    req_url <- paste0(base_url, endpoint, "?token=", token, "&stid=", wh_station, "&units=", units)
  } else {
    if (!(wh_state %in% datasets::state.abb)) { # check if state is valid
      stop("state not valid")
    }
    req_url <- paste0(base_url, endpoint, "?token=", token, "&state=", wh_state, "&units=", units)
  }

  # Send the API request and get response
  resp_parsed <- execute_api_request(req_url)

  # the data we want is the "STATION" variable in the list
  df <- resp_parsed$STATION

  # each row in df corresponds to one station
  # each station/row contains a dataframe with the observations
  obs_names <- names(df$OBSERVATIONS)
  df2 <- tidyr::unnest(df,'OBSERVATIONS') # unpack the OBSERVATIONS data frame

  # the OBSERVATIONS dataframe contains a data frame for each measurement; unpack again
  df4 <- tidyr::unnest(df2, tidyselect::all_of(obs_names),names_sep = "_")

  df4$air_temp_value_1_date_time <- lubridate::as_datetime(df4$air_temp_value_1_date_time)

  df4$LATITUDE <- as.numeric(df4$LATITUDE)
  df4$LONGITUDE <- as.numeric(df4$LONGITUDE)



  return(df4)

}
