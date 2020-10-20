#' @import shiny
app_server <- function(input, output,session) {
  # List the first level callModules here
  
  callModule(mod_long_profiles_server, "long_profiles_ui_1")
  callModule(mod_regional_models_server, "regional_models_ui_1")
}
