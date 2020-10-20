# Launch the ShinyApp (Do not remove this comment)
# To deploy, run: rsconnect::deployApp()
# Or use the blue button on top of this file

pkgload::load_all()
options( "golem.app.prod" = TRUE)
mylibraries=c(.libPaths(),
              "../../../R/x86_64-pc-linux-gnu-library/3.5")
library(vctrs,lib.loc=mylibraries)
library(rlang,lib.loc=mylibraries)
mapdO::run_app() # add parameters here (if any)
