#' Get datapath towards file with metric data for a river
#' @param axis river id
#' @param zvar metric
#' @return path towards metric data for river
#' @export 
#' @examples
#' get_datapath("AX0005","talweg_slope")
get_datapath=function(axis,zvar){
  if(!is.null(zvar)){
    filename=table_metrics %>% 
      dplyr::filter(varname==zvar) %>%
      dplyr::pull(filename)
    path=glue::glue("data-raw/AXES/{axis}/METRICS/{filename}.csv")
    if(!file.exists(path)){path=NULL}
    return(path)
  }
}

#' Get data regarding metric for a river
#' @param axis river id
#' @param zvar metric
#' @return tibble with data xvar and zvar
#' @export
#' @examples
#' get_data("AX0005","talweg_slope")
get_data=function(axis,zvar){
  path=get_datapath(axis,zvar)
  if(is.null(path)){return(NULL)}
  tibinput=table_metrics %>%
    dplyr::filter(varname==zvar)
  lvar=table_metrics %>% 
    dplyr::filter(filename==tibinput$filename,
           typelzk=="l") %>% 
    dplyr::pull(varname)
  datacsv=readr::read_csv2(path)%>% 
      dplyr::select(dplyr::everything(),
                    lvar=dplyr::matches(paste0("^",lvar,"$")),
                    zvar=dplyr::matches(paste0("^",zvar,"$"))) %>% 
      dplyr::mutate(lvar=lvar/1000) %>% 
      dplyr::arrange(lvar)
  return(datacsv)
}

#' Get labels regarding metric
#' @param zvar metric
#' @return tibble with labels xlab and ylab
#' @export
#'
#' @examples
#' get_labels(zvar="landcover_width")
get_labels=function(zvar){
  fileinput=table_metrics %>% 
    dplyr::filter(varname==zvar) %>% 
    dplyr::pull(filename)
  if(length(fileinput)==0){return(NULL)}
  tibfile=table_metrics %>% 
    dplyr::filter(filename==fileinput) 
  lvar=tibfile %>% 
    dplyr::filter(typelzk=="l") %>% 
    dplyr::pull(varname)
  res=tibble::tibble(
    filename=c(fileinput,fileinput),
    var=c("lvar","zvar"),
    varname=c(lvar,zvar),
    label=c(tibfile %>%
              dplyr::filter(varname==lvar) %>%
              dplyr::pull(label),
            tibfile %>%
              dplyr::filter(varname==zvar) %>%
              dplyr::pull(label)
            )
    )
  
  return(res)
}

#' Get info (data+labels) regarding metric for a river
#'
#' @param axis river id
#' @param zvar metric
#' @return list with data and labels
#' @export
#'
#' @examples
#' get_info(axis="AX0005",zvar="landcover_area")
get_info=function(axis, zvar){
  data=get_data(axis=axis,zvar=zvar)
  labels=get_labels(zvar=zvar)
  typevar=labels$filename %>% unique()

  river=dattib %>% 
    dplyr::filter(ID==axis) %>%
    dplyr::pull(TOPONYME) %>% 
    as.vector() %>% 
    unique()
  info=list(data=data,
            labels=labels,
            typevar=typevar,
            river=river)
  return(info)
}


#' Get polyline for a river
#'
#' @param axis river id
#' @return polyline corresponding to river
#' @export
#' @examples
#' get_shape("AX0005")
get_shape=function(axis){
  shp=dplyr::filter(datsf, ID==axis)
  return(shp)
}
#' Get coords for a river
#'
#' @param axis river id
#' @return coords corresponding to river
#' @export
#' @examples
#' get_coords("AX0005")
get_coords=function(axis){
  shp=sf::st_read(glue::glue("data-raw/AXES/{axis}/MEASURE/SWATHS_REFAXIS.shp")) %>% 
    sf::st_centroid() %>% 
    sf::st_transform(4326) 
 return(shp)
}

get_available_info=function(axis){
  dir=glue::glue("data-raw/AXES/{axis}/METRICS/")
  available=list.files(dir) %>% 
    stringr::str_subset("\\.csv") %>% 
    stringr::str_replace("\\.csv","")
  return(available)
}
