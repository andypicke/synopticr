#' Get latest data from weather stations
#'
#' @param wh_state State to get data for
#' @param token token (api key). Default is Sys.getenv("SYNOPTIC_API_KEY")
#'
#' @return Dataframe
#' @export
get_latest_data <- function(wh_state = "CO", token = Sys.getenv("SYNOPTIC_API_KEY")){


  base_url <- "https://api.synopticdata.com/v2/"

  endpoint <- "stations/latest"
  #
  req_url <- paste0(base_url,endpoint,"?token=", token, "&state=", wh_state)
  #req_url <- paste0(base_url,endpoint,"?token=", token)
  #req_url <- paste0(base_url,endpoint,"?token=", token, "&stid=", station_id)

  # Send the API request and get response
  #resp <- httr::GET(req_url)
  #resp$status_code
  #resp_parsed <- jsonlite::fromJSON(httr::content(resp, as = "text", encoding = "UTF-8"))
  resp_parsed <- execute_api_request(req_url)

  # the data we want is the "STATION" variable in the list
  df <- resp_parsed$STATION

  # each station (row) contains a dataframe with observations; unpack into same dataframe
  df2 <- tidyr::unnest(df,'OBSERVATIONS')

}
