#' @import shiny
#' @export
app_ui <- function() {
  navbarPage(
    title =
      div(
        img(
          src = "www/mapdO.png",
          height = 40,
          width = 100,
          style = "margin:-11px -12px"
        )
      ),#"MapdO",#tags$img(src = "www/mapdO.png", height = 50, width = 50),
    tabPanel("Profils",mod_long_profiles_ui("long_profiles_ui_1")),
    tabPanel("Modèle régional",mod_regional_models_ui("regional_models_ui_1")),
    tabPanel("Test dev",mod_test_ui("test_ui_1"))
  )
}
# 

#' @import shiny
golem_add_external_resources <- function(){
  
  addResourcePath(
    'www', system.file('app/www', package = 'mapdO')
  )
 
  tags$head(
    golem::activate_js(),
    golem::favicon()
    # Add here all the external resources
    # If you have a custom.css in the inst/app/www
    # Or for example, you can add shinyalert::useShinyalert() here
    #tags$link(rel="stylesheet", type="text/css", href="www/custom.css")
  )
}
