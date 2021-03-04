
#' Produces scatterplot of y against x
#' @param x x variable name in the regional dataset (with quotes)
#' @param y y variable name in the regional dataset (with quotes)
#' @return scatterplot
#' @export
#' @examples
#' calc_regmod(datRMC,
#' "surface de la bande fluviale",
#' "surface de la bande active")
calc_regmod=function(data,x,y, xtrans,ytrans){
  xname=table_regmod %>% 
    dplyr::filter(label==x) %>% 
    dplyr::pull(name)
  yname=table_regmod %>% 
    dplyr::filter(label==y) %>% 
    dplyr::pull(name)
  data$xvar=get(xtrans)(data[[xname]])
  data$yvar=get(ytrans)(data[[yname]])
  # data=data %>% 
  #   dplyr::select(xvar,yvar) %>% 
  #   na.omit()
  model=lm(yvar~xvar,data=data)
  data=data %>% 
    dplyr::mutate(residuals=model$residuals) %>% 
    dplyr::mutate(relpos=dplyr::min_rank(residuals)) %>% 
    dplyr::mutate(relpos=relpos/max(relpos))
  return(list(data=data,model=model, labels=c(x,y)))
}


#' Produces scatterplot of y against x
#' @param data_mod a model
#' @return scatterplot
#' @export
#' @examples
#' data_mod=calc_regmod(datRMC %>% sf::st_drop_geometry(),
#'  "surface de la bande fluviale",
#'  "surface de la bande active")
#' plot_regmod(data_mod)
plot_regmod=function(data_mod){
  pal=define_palette(data_mod$data$relpos)
  data_mod$data$vcolor=as.factor(round(data_mod$data$relpos,1))
  ggplot2::ggplot(data_mod$data, ggplot2::aes(x=xvar,y=yvar))+
    ggplot2::geom_point(ggplot2::aes(color=vcolor))+
    ggplot2::geom_smooth(method="lm")+
    ggplot2::labs(x=data_mod$labels[1],y=data_mod$labels[2])+
    ggplot2::scale_color_manual(values=pal(seq(0,1,by=0.1)),
                                limits=seq(0,1,by=0.1))
}

