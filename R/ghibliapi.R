#' Retrieve data from the Ghibli API
#' @param  type The endpoint type, one of 'films', 'species', 'people', 'vehicles' or 'locations'.
#' Default to NULL if nothing is provided.
#' @param id The object index. Default is all unless an id is specified.
#' @return Either a data.frame (if id is NULL) or a list
#' @references https://ghibliapi.herokuapp.com
#' @export
#' @examples
#'  get_ghibli(type="films")
#'  get_ghibli(type="people",id="986faac6-67e3-4fb8-a9ee-bad077c2e7fe")
#'  \dontrun{
#'  require("tidyverse")
#'  get_ghibli("species") %>%
#'  filter(name=="Cat") %>%
#'  select(id) %>%
#'  get_ghibli("species",id=.) %>%
#'  subset(.,str_detect(.,"people")) %>%
#'  str_replace("https://ghibliapi.herokuapp.com/people/","") %>%
#'  map(~ get_ghibli("people",.)) %>%
#'  {
#'   tibble(
#'   name = map_chr(., "name"),
#'   gender = map_chr(., "gender"),
#'   eye_color = map_chr(., "eye_color"),
#'   hair_color = map_chr(., "hair_color")
#'   )
#'  }
#' }
get_ghibli <- function(type = NULL, id = NULL){
  if(is.null(type)) return("type should be either 'films', 'species', 'people', 'vehicles' or 'locations'")
  if(!type %in% c("films","species","people","vehicles","locations")) stop("type should be either 'films', 'species', 'people', 'vehicles' or 'locations'")
  r <- GET(getOption("REST.URL"), path = paste0(type, "/", id))
  if (r$status_code != 200) {
    stop_for_status(r)
    } else {
      tmp <- content(r)
      }
  if(type == "films")     out <- ghibli_films(tmp, id = id)
  if(type == "species")   out <- ghibli_species(tmp, id = id)
  if(type == "people")    out <- ghibli_people(tmp, id = id)
  if(type == "locations") out <- ghibli_locations(tmp, id = id)
  if(type == "vehicles")  out <- ghibli_vehicles(tmp, id = id)
  return(out)
}
ghibli_films <- function(tmp=tmp, id=NULL){
        if(is.null(id)) {
        response <- matrix(unlist(tmp, recursive=F), length(tmp), 12, byrow=T)
        response <- data.frame(id=unlist(response[,1],recursive = F),
                           title=unlist(response[,2]),
                           description=unlist(response[,3]),
                           director=unlist(response[,4]),
                           producer=unlist(response[,5]),
                           release_date=unlist(response[,6]),
                           rt_score=as.numeric(unlist(response[,7])),
                           stringsAsFactors = F)
        } else {
            response <- unlist(tmp, recursive=F)
    }
    return(response)
}
ghibli_people <- function(tmp=tmp, id=NULL){
    if(is.null(id)) {
      response <- matrix(unlist(tmp, recursive=F), length(tmp), 8, byrow=T)
      response <- data.frame(id=unlist(response[,1],recursive = F),
                             name=unlist(response[,2]),
                             gender=unlist(response[,3]),
                             age=unlist(response[,4]),
                             eye_color=unlist(response[,5]),
                             hair_color=unlist(response[,6]),
                             stringsAsFactors = F)
      } else {
        response <- unlist(tmp, recursive=F)
        }
  return(response)
  }
ghibli_species <- function(tmp=tmp, id=NULL){
    if(is.null(id)) {
        response <- matrix(unlist(tmp, recursive=F), length(tmp), 8, byrow=T)
        response <- data.frame(id=unlist(response[,1],recursive = F),
                               name=unlist(response[,2]),
                               classification=unlist(response[,3]),
                               eye_colors=unlist(response[,4]),
                               hair_colors=unlist(response[,5]),
                               stringsAsFactors = F)
    } else {
        response <- unlist(tmp, recursive=F)
    }
    return(response)
}
ghibli_locations <- function(tmp=tmp, id=NULL){
    if(is.null(id)) {
        response <- matrix(unlist(tmp, recursive=F), length(tmp), 8, byrow=T)
        response <- data.frame(id=unlist(response[,1],recursive = F),
                               name=unlist(response[,2]),
                               climate=unlist(response[,3]),
                               terrain=unlist(response[,4]),
                               surface_water=unlist(response[,5]),
                               stringsAsFactors = F)
    } else {
        response <- unlist(tmp, recursive=F)
    }
    return(response)
}
ghibli_vehicles <- function(tmp=tmp, id=NULL){
    if(is.null(id)) {
        response <- matrix(unlist(tmp, recursive=F), length(tmp), 8, byrow=T)
        response <- data.frame(id=unlist(response[,1],recursive = F),
                               name=unlist(response[,2]),
                               description=unlist(response[,3]),
                               vehicle_class=unlist(response[,4]),
                               lenght=unlist(response[,5]),
                               stringsAsFactors = F)
    } else {
        response <- unlist(tmp, recursive=F)
    }
    return(response)
}

