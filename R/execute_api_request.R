
#' Execute API request and return parsed content
#'
#' @param req_url URL for API request
#'
#' @return List of parsed response
#' @export
#'
execute_api_request <- function(req_url){

  resp <- httr::GET(req_url)

  # check status code
  #  resp$status_code

  # parse the content from the request
  resp_parsed <- jsonlite::fromJSON(httr::content(resp, as = "text", encoding = "UTF-8"))

}
