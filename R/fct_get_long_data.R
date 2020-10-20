get_data=function(axis,inputtype){
  if(!is.null(inputtype)){
  tibinput=tibcorr %>% 
    dplyr::filter(type==inputtype)
  filename=tibinput %>% dplyr::pull(filename)
  ncpath=glue::glue("{dat.path}/axis{axis}/{filename}.nc")
  datanc=tidync::tidync(ncpath)%>% 
    tidync::hyper_tibble() 
  datanc=datanc%>% 
    dplyr::select(dplyr::everything(),
                  xvar=dplyr::matches(tibinput %>% dplyr::pull(xname)),
                  yvar=dplyr::matches(tibinput %>% dplyr::pull(yname))) %>% 
    dplyr::arrange(xvar)
  return(datanc)
  }
}
