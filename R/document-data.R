#' table documenting possible types of profiles
#'
#' Lists possible metrics and corresponding filenames,
#' as well as corresponding names for x-y variables
#' in profiles and corresponding labels in plots.
#'
#' @format A tibble with 4 variables
#' \describe{
#'   \item{filename}{corresponding file name}
#'   \item{varname}{variable name (as stated in the .nc files)}   
#'   \item{unit}{variable name to be used as y for plotting profile}
#'   \item{explain}{used as label for x axis when plotting profile}   
#'   \item{typelzk}{type of variable: l for longitudinal coordinate, z for metric, k for other -e.g. class of landcover-}
#'   \item{label}{used as label for axes when plotting profiles}
#' }
"table_metrics"


#' table documenting possible types of regional models
#'
#' Lists possible variable names and corresponding labels.
#'
#' @format A tibble with variables
#' \describe{
#'   \item{name}{possible metric type (as asked for in the app)}
#'   \item{label}{corresponding file name}
#' }
"table_regmod"


