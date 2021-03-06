% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fct_plots.R
\name{plot_continuity_profiles}
\alias{plot_continuity_profiles}
\title{Plot metric along river}
\usage{
plot_continuity_profiles(info, facets = "Unique", keep = NA)
}
\arguments{
\item{info}{information about axis and z metric: data with columns named lvar and zvar and labels}
}
\value{
a plot showing zvar against lvar
}
\description{
Plot metric along river
}
\examples{
plot_continuity_profiles(info=get_info(axis="AX0005", zvar="sw_continuity_max"), 
facets="Multiple",
keep=c("Active channel", "Riparian corridor"))
}
