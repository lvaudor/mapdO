
#' Produce leaflet map to be used as a basis for displaying layers
#' 
#' @return leaflet map
#' @export
#'
#' @examples
#' basic_map()
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
#' @return
#' @export
#'
#' @examples
#' basic_map() %>% add_rivers_to_map(datsp)
add_rivers_to_map=function(map,spdata){
  map %>% 
    leaflet::addPolylines(data = spdata,
                          layerId=spdata$axis,
                          color = ~mypalette(strahler),
                          popup= ~popup)
}

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

get_rivers_from_scatterplot=function(xvar,yvar,brush_xmin,brush_xmax,brush_ymin,brush_ymax){
  id=datRMC %>% 
    dplyr::mutate_(xvar=xvar,
                   yvar=yvar) %>% 
    dplyr::filter(xvar>=brush_xmin,
                  xvar<=brush_xmax,
                  yvar>=brush_ymin,
                  yvar<=brush_ymax) %>% 
    dplyr::pull(idn)
  return(id)
}