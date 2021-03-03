#' @return palette
mypalette = function(){
  leaflet::colorNumeric(
  palette = "Blues",
  domain = 0:7)
}