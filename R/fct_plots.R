#' Plot metric along river
#'
#' @param info information about axis and z metric: data with columns named lvar and zvar and labels
#' @return a plot showing zvar against lvar
#' @export
#' @examples
#' plot_profiles(info=get_info(axis="AX0005", zvar="talweg_curvature"))
plot_profiles=function(info){
  if(is.null(info$data)){return(NULL)}
  p=ggplot2::ggplot(info$data, ggplot2::aes(x=rev(lvar),y=zvar))+
    ggplot2::labs(x=info$labels %>% dplyr::filter(var=="lvar") %>% dplyr::pull(label),
                  y=info$labels %>% dplyr::filter(var=="zvar") %>% dplyr::pull(label))+
    ggplot2::geom_path()+
    ggplot2::ggtitle(info$river)+
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
  return(p)
}

#' Plot metric along river
#'
#' @param info information about axis and z metric: data with columns named lvar and zvar and labels
#' @return a plot showing zvar against lvar
#' @export
#' @examples
#' plot_landcover_profiles(info=get_info(axis="AX0005", zvar="landcover_width"), 
#' facets="Multiple",
#' keep=c("Crops","Dense Urban","Diffuse Urban"))
plot_landcover_profiles=function(info, facets="Unique", keep=NA){
  if(is.null(info$data)){return(NULL)}
  if(!is.na(keep[1])){
    info$data=info$data %>%
      dplyr::filter(landcover %in% keep)
  }
  p=ggplot2::ggplot(info$data, ggplot2::aes(x=rev(lvar),y=zvar))+
    ggplot2::labs(x=info$labels %>% dplyr::filter(var=="lvar") %>% dplyr::pull(label),
                  y=info$labels %>% dplyr::filter(var=="zvar") %>% dplyr::pull(label))+
    ggplot2::geom_path(ggplot2::aes(color=landcover))+
    ggplot2::ggtitle(info$river)+
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
  if(facets=="Multiple"){
    p=p+ggplot2::facet_wrap(facets=ggplot2::vars(landcover), ncol=1)
  }
  return(p)
}

#' Plot metric along river
#'
#' @param info information about axis and z metric: data with columns named lvar and zvar and labels
#' @return a plot showing zvar against lvar
#' @export
#' @examples
#' plot_historic_profiles(info=get_info(axis="AX0001", zvar="historic_area"), 
#' keep_landcover=c("Active Channel","Gravel bars"),
#' keep_time=c(1938,1990,2019))
plot_historic_profiles=function(info, keep_landcover=NA, keep_time=NA){
  if(is.null(info$data)){return(NULL)}
  if(!is.na(keep_landcover[1])){
    info$data=info$data %>%
      dplyr::filter(landcover %in% keep_landcover)
  }
  if(!is.na(keep_time[1])){
    info$data=info$data %>%
      dplyr::filter(time %in% keep_time)
  }
  p=ggplot2::ggplot(info$data, ggplot2::aes(x=rev(lvar),y=zvar))+
    ggplot2::labs(x=info$labels %>% dplyr::filter(var=="lvar") %>% dplyr::pull(label),
                  y=info$labels %>% dplyr::filter(var=="zvar") %>% dplyr::pull(label))+
    ggplot2::geom_path(ggplot2::aes(color=landcover))+
    ggplot2::ggtitle(info$river)+
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
    p=p+ggplot2::facet_wrap(facets=ggplot2::vars(time), ncol=1)
  return(p)
}

#' Plot metric along river
#'
#' @param info information about axis and z metric: data with columns named lvar and zvar and labels
#' @return a plot showing zvar against lvar
#' @export
#' @examples
#' plot_continuity_profiles(info=get_info(axis="AX0005", zvar="sw_continuity_max"), 
#' facets="Multiple",
#' keep=c("Active channel", "Riparian corridor"))
plot_continuity_profiles=function(info, facets="Unique", keep=NA){
  if(is.null(info$data)){return(NULL)}
  if(!is.na(keep[1])){
    info$data=info$data %>%
      dplyr::filter(continuity %in% keep)
  }
  p=ggplot2::ggplot(info$data, ggplot2::aes(x=rev(lvar),y=zvar))+
    ggplot2::labs(x=info$labels %>% dplyr::filter(var=="lvar") %>% dplyr::pull(label),
                  y=info$labels %>% dplyr::filter(var=="zvar") %>% dplyr::pull(label))+
    ggplot2::geom_path(ggplot2::aes(color=continuity))+
    ggplot2::ggtitle(info$river)+
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))+
  if(facets=="Multiple"){
    p=p+ggplot2::facet_wrap(facets=ggplot2::vars(continuity), ncol=1)
  }
  return(p)
}
