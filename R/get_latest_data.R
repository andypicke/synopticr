#' Get latest data from weather stations
#'
#' @param wh_state State to get data for
#' @param token token (api key). Default is Sys.getenv("SYNOPTIC_API_KEY")
#'
#' @return Dataframe
#' @export
#'
#' @examples latest <- get_latest_data()
get_latest_data <- function(wh_state = "CO", token = Sys.getenv("SYNOPTIC_API_KEY")){


  base_url <- "https://api.synopticdata.com/v2/"

  endpoint <- "stations/latest"
  #
  req_url <- paste0(base_url,endpoint,"?token=", token, "&state=", wh_state)
  #req_url <- paste0(base_url,endpoint,"?token=", token)
  #req_url <- paste0(base_url,endpoint,"?token=", token, "&stid=", station_id)
  resp <- httr::GET(req_url)

#  resp$status_code

  resp_parsed <- jsonlite::fromJSON(httr::content(resp, as = "text", encoding = "UTF-8"))

  df <- resp_parsed$STATION

  df2 <- tidyr::unnest(df,'OBSERVATIONS') # each station (row) contains a dataframe with observations

}
