
#' Get info on available networks
#'
#' @param token token (api key). Default is Sys.getenv("SYNOPTIC_API_KEY")
#'
#' @return Dataframe of networks and information
#' @export
#'
#' @examples networks <- get_networks()
get_networks <- function(token = Sys.getenv("SYNOPTIC_API_KEY")){
  base_url <- "https://api.synopticdata.com/v2/"
  endpoint <- "networks"
  req_url <- paste0(base_url,endpoint,"?token=", token)
  resp <- httr::GET(req_url)
  resp_parsed <- jsonlite::fromJSON(httr::content(resp, as = "text", encoding = "UTF-8"))

  df <- resp_parsed$MNET # for networks
}
