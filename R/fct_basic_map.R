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
#' @param sp the polylines spatial data corresponding to rivers that will be added to the leaflet map
#'
#' @return map with river lines
#' @export
#' @examples 
#' basic_map() %>%
#'  add_rivers_to_map(sfdata=datsf ,vcolor=NA,vpopup="ID")
add_rivers_to_map=function(map,
                           sfdata,
                           group="base",
                           vlayerId="ID",
                           vcolor=NA,
                           color="grey",
                           vpopup="popup"){
  sfdata=sfdata %>% 
    dplyr::mutate_(popup=vpopup,
                   layerId=vlayerId) %>% 
    dplyr::mutate(color=rep(color,nrow(sfdata)))
  if(!is.na(vcolor)){
    sfdata=sfdata %>% 
      dplyr::mutate_(color=vcolor)
    pal=define_palette(sfdata$color)
    sfdata=sfdata %>% 
        dplyr::mutate(color=pal(sfdata$color))
  }
  map %>% 
    leaflet::addPolylines(data = sfdata,
                          group=group,
                          layerId= ~sfdata$layerId,
                          popup= ~sfdata$popup,
                          color= ~sfdata$color)
}

#' Get bounds of rectangle (on map) based on rectangle on plot
#'
#' @param profile_data profile_data
#' @param lmin minimum distance along axis
#' @param lmax maximum distance along axis
#'
#' @return data with min-max of lng and min-max of lat
#' @export
#' @examples 
#' get_rect_bounds_from_profile(axis="AX0005", lmin=1500, lmax=3000)
get_rect_bounds_from_profile=function(axis,lmin,lmax){
    shp=mapdO:::get_coords(axis)
    coords=shp %>%
        dplyr::filter(M>=lmin,M<=lmax) %>% 
        sf::st_coordinates() %>% 
        tibble::as_tibble() %>% 
        dplyr::summarise(minlng=min(X),
                         maxlng=max(X),
                         minlat=min(Y),
                         maxlat=max(Y))
  dat=data.frame(lng=c(coords$minlng,coords$maxlng),
                 lat=c(coords$minlat,coords$maxlat))
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
get_rivers_from_scatterplot=function(xvar,
                                     yvar,
                                     brush_xmin,
                                     brush_xmax,
                                     brush_ymin,
                                     brush_ymax,
                                     xtrans,
                                     ytrans){
  id=datRMC %>% 
    dplyr::select(xvar=dplyr::matches(xvar),
                  yvar=dplyr::matches(yvar),
                  idn=idn) %>% 
    dplyr::mutate(xvar=get(xtrans)(xvar),
                  yvar=get(ytrans)(yvar)) %>% 
    sf::st_drop_geometry() %>% 
    dplyr::filter(xvar>=brush_xmin,
                  xvar<=brush_xmax,
                  yvar>=brush_ymin,
                  yvar<=brush_ymax) %>% 
    dplyr::pull(idn)
  return(id)
}