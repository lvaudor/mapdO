#' Produce leaflet map to be used as a basis for displaying layers
#' 
#' @return leaflet map
#' @export
basic_map=function(){
  map=leaflet::leaflet() %>%
    leaflet::addProviderTiles(leaflet::providers$Stamen.TonerLite,
                              options = leaflet::providerTileOptions(noWrap = TRUE)) %>% 
    leaflet::fitBounds(lng1=3,
                       lng2=8,
                       lat1=43,
                       lat2=48)
  map
}


#' Title
#'
#' @param map a leaflet map
#' @param spdata the polylines spatial data corresponding to rivers that will be added to the leaflet map
#'
#' @return map with river lines
#' @export
#' @examples basic_map() %>% add_rivers_to_map(datsp)
add_rivers_to_map=function(map,spdata){
  map %>% 
    leaflet::addPolylines(data = spdata,
                          layerId=spdata$axis,
                          color = ~mypalette(strahler),
                          popup= ~popup)
}

#' Get bounds of rectangle (on map) based on rectangle on plot
#'
#' @param obj_id river id
#' @param lmin minimum distance along axis
#' @param lmax maximum distance along axis
#'
#' @return data with min-max of lng and min-max of lat
#' @export
get_rect_bounds_from_profile=function(obj_id,lmin,lmax){
  res=datsp %>% 
    subset(axis == obj_id) %>% 
    subset(invm>lmin & invm<lmax) %>% 
    sp::bbox() %>% 
    as.numeric()
  dat=data.frame(lng=c(res[1],res[3]),
                 lat=c(res[2],res[4]))
  return(dat)
}

#' Title
#'
#' @param xvar name of variable x
#' @param yvar name of variable y
#' @param brush_xmin xmin of considered objects
#' @param brush_xmax xmax of considered objects
#' @param brush_ymin ymin of considered objects
#' @param brush_ymax ymax of considered objects
#'
#' @return river ids
#' @export
get_rivers_from_scatterplot=function(xvar,yvar,brush_xmin,brush_xmax,brush_ymin,brush_ymax){
  id=datRMC %>% 
    dplyr::select(xvar=dplyr::matches(xvar),
                  yvar=dplyr::matches(yvar),
                  idn=idn) %>% 
    sf::st_drop_geometry() %>% 
    dplyr::filter(xvar>=brush_xmin,
                  xvar<=brush_xmax,
                  yvar>=brush_ymin,
                  yvar<=brush_ymax) %>% 
    dplyr::pull(idn)
  return(id)
}