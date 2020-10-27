golem::detach_all_attached()

mylibraries=c(.libPaths(),
              "../../../R/x86_64-pc-linux-gnu-library/3.5")
library(shiny,lib.loc=mylibraries)
library(mapdO,lib.loc=mylibraries)
library(vctrs,lib.loc=mylibraries)
library(rlang,lib.loc=mylibraries)
library(dplyr,lib.loc=mylibraries)
library(sf, lib.loc=mylibraries)
shinyApp(ui=mapdO::app_ui,server=mapdO::app_server) # add parameters here (if any)# Launch the ShinyApp (Do not remove this comment)
# To deploy, run: rsconnect::deployApp()
# Or use the blue button on top of this file
