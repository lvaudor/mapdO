#' Title
#'
#' @param spdata 
#' @param bounds 
#'
#' @return
#' @export
#'
#' @examples
subset_spdata=function(spdata,bounds){
  
  if (is.null(bounds)){return(spdata)}
  latRng <- range(bounds$north, bounds$south)
  lngRng <- range(bounds$east, bounds$west)
  
  sub_spdata= subset(spdata,
                     ymin >= latRng[1] & ymax <= latRng[2] &
                     xmin >= lngRng[1] & xmax <= lngRng[2])  
  return(sub_spdata)
}