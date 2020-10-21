#' Get data regarding metric for a river
#'
#' @param axis river id
#' @param y metric
#'
#' @return
#' @export
#'
#' @examples
#' get_data(1,"Long profile(m)")
get_data=function(axis,y){
  if(!is.null(y)){
  tibinput=table_profiles %>% 
    dplyr::filter(type==y)
  filename=tibinput %>%
    dplyr::pull(filename)
  ncpath=glue::glue("{dat.path}/axis{axis}/{filename}.nc")
  datanc=tidync::tidync(ncpath)%>% 
    tidync::hyper_tibble() %>% 
    dplyr::select(dplyr::everything(),
                  xvar=dplyr::matches(tibinput %>% dplyr::pull(xname)),
                  yvar=dplyr::matches(tibinput %>% dplyr::pull(yname))) %>% 
    dplyr::arrange(xvar)
  return(datanc)
  }
}
