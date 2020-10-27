datsf=sf::st_read("data-raw/global/REFERENTIEL_HYDRO.shp") %>% 
  sf::st_zm() %>%
  sf::st_simplify(dTolerance=100) %>% 
  sf::st_transform(4326) %>% 
  dplyr::mutate(popup=paste(axis,toponyme,cdentitehy,sep="-")) %>%
  dplyr::group_by(axis) %>% 
  dplyr::mutate(maxm=max(measure)) %>% 
  dplyr::mutate(invm=maxm-measure) %>%
  dplyr::ungroup()
datsp=sf::as_Spatial(datsf)
usethis::use_data(datsp, overwrite=T)
usethis::use_data(datsf, overwrite=T)

datncE=tidync::tidync("data-raw/global/donneesElise/BD_RhoneMediterraneeCorse.nc") %>% 
  tidync::hyper_tibble() %>% 
  dplyr::mutate(idn=1:dplyr::n()) 
datRMC=sf::st_read("data-raw/global/donneesElise/networkElise_continu.shp") %>% 
  sf::st_simplify(dTolerance=100) %>% 
  sf::st_transform(4326) %>% 
  dplyr::mutate(idn=1:dplyr::n()) %>% 
  dplyr::left_join(datncE,by="idn") %>% 
  dplyr::mutate(strahler=m_strahler,
                axis=idn) %>% 
  dplyr::mutate(popup=paste(axis,TOPONYME,sep="-")) %>% 
  dplyr::mutate(bbox=purrr::map(.$geometry,sf::st_bbox)) %>% 
  dplyr::mutate(xmin=purrr::map(bbox,"xmin"),
                xmax=purrr::map(bbox,"xmax"),
                ymin=purrr::map(bbox,"ymin"),
                ymax=purrr::map(bbox,"ymax")) %>% 
  dplyr::select(-bbox)

datRMCsp=datRMC %>% sf::as_Spatial()
usethis::use_data(datRMC, overwrite=TRUE)
usethis::use_data(datRMCsp, overwrite=TRUE)


