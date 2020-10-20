basic_map=function(spdata){
  map=leaflet::leaflet() %>%
    leaflet::addProviderTiles(leaflet::providers$Stamen.TonerLite,
                              options = leaflet::providerTileOptions(noWrap = TRUE)) %>%
    leaflet::addPolylines(data = spdata,
                          layerId=spdata$axis,
                          color = ~mypalette(strahler),
                          popup= ~popup)
  map
}



get_map_bounds=function(clickedaxis,lmin,lmax){
  res=datsf %>% 
    dplyr::filter(axis==clickedaxis) %>% 
    dplyr::mutate(invm=max(measure)-measure) %>% 
    dplyr::filter(invm>lmin & invm<lmax) %>% 
    sf::st_geometry() %>% 
    sf::as_Spatial() %>% 
    sp::bbox() %>% 
    as.numeric()
  dat=data.frame(lng=c(res[1],res[3]),
                 lat=c(res[2],res[4]))
  return(dat)
}
