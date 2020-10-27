#' Plot metric along river
#'
#' @param dat data with columns named xvar and yvar
#' @param y y-axis label
#' @return a plot showing yvar against xvar
#' @export
#' @examples
#' plot_profiles(dat=get_data(axis=1, y="LONG_PROFILE"),
#'               y="height (m)")
plot_profiles=function(dat,y){
  p=ggplot2::ggplot(dat, ggplot2::aes(x=rev(xvar),y=yvar))+
  ggplot2::labs(x="distance along axis",
                y=y)
  if(stringr::str_detect(y,"LANDCOVER")){
    p=p+ggplot2::geom_path(ggplot2::aes(color=landcover))
  }else{p=p+ggplot2::geom_path()}
  return(p)
}

#' Produces scatterplot of y against x
#' @param x variable name in the regional dataset (with quotes)
#' @param y variable name in the regional dataset (with quotes)
#' @return scatterplot
#' @export
#' @examples
#' plot_regmod("m_surf_bf","m_lrgm_ba")
plot_regmod=function(x,y){
  ggplot2::ggplot(datRMC, ggplot2::aes_string(x=x,y=y))+
    ggplot2::geom_point()+
    ggplot2::geom_smooth(method="lm")
}
