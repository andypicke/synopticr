#' Get station metadata from synopticdata API
#'
#' @param wh_state State to get info for. Default "CO"
#' @param token token (api key). Default is Sys.getenv("SYNOPTIC_API_KEY")
#'
#' @return df: Data frame of requested station metadata
#' @export
#'
#' @examples meta <- get_metadata()
get_metadata <- function(wh_state = "CO", token = Sys.getenv("SYNOPTIC_API_KEY")){

  base_url <- "https://api.synopticdata.com/v2/"

  endpoint <- "stations/metadata"

  req_url <- paste0(base_url,endpoint,"?token=", token, "&state=", wh_state)

  # Send the API request and get response
  resp_parsed <- execute_api_request(req_url)

  df <- resp_parsed$STATION # for data

  df$LATITUDE <- as.numeric(df$LATITUDE)
  df$LONGITUDE <- as.numeric(df$LONGITUDE)

  return(df)

}
