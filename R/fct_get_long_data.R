#' Get datapath towards file with metric data for a river
#'
#' @param axis river id
#' @param y metric
#'
#' @return path towards metric data for river
#' @export 
#'
#' @examples
#' get_datapath(1,"Profil en long (m)")
get_datapath=function(axis,y){
  if(!is.null(y)){
    tibinput=table_profiles %>% 
      dplyr::filter(type==y)
    filename=tibinput %>%
      dplyr::pull(filename)
    if(length(filename)==0){stop("There is no datafile for this.")}
    ncpath=glue::glue("data-raw/axes/axis{axis}/{filename}.nc")
    return(ncpath)
  }
}

#' Get data regarding metric for a river
#'
#' @param axis river id
#' @param y metric
#'
#' @return tibble with data xvar and yvar
#' @export
#'
#' @examples
#' get_data(1,"Profil en long (m)")
get_data=function(axis,y){
ncpath=get_datapath(axis,y)
tibinput=table_profiles %>% 
  dplyr::filter(type==y)
  datanc=tidync::tidync(ncpath)%>% 
    tidync::hyper_tibble() %>% 
    dplyr::select(dplyr::everything(),
                  xvar=dplyr::matches(tibinput %>% dplyr::pull(xname)),
                  yvar=dplyr::matches(tibinput %>% dplyr::pull(yname))) %>% 
    dplyr::arrange(xvar)
  return(datanc)
}
