#' regional_models UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_regional_models_ui <- function(id){
  ns <- NS(id)
  fluidPage(
    fluidRow(
      column(width=6,
             h1("select axis")
             # radioButtons(ns("selectaxistype"),
             #              label="Choisir un axe",
             #              choices=c("en cliquant sur la carte",
             #                        "depuis un menu déroulant"),
             #              selected="en cliquant sur la carte"),
             # uiOutput(ns("menu"))
             
      ),#column
      column(width=6,
             h1("select")
             #uiOutput(ns("selectdescriptor"))
      )#column
    ),#fluidRow
    fluidRow(
      column(width=6,
             leaflet::leafletOutput(ns("map2"))
      ),#column
      column(width=6,
             h1("plot")
             #plotOutput(ns("plot"),
             #          brush = ns("plot_brush"))
      )#column
    )
  )#fluidPage
}
    
#' regional_models Server Function
#'
#' @noRd 
mod_regional_models_server <- function(input, output, session){
  ns <- session$ns
  output$map2 <- leaflet::renderLeaflet({
    basic_map(datRMCsp)
  })
}
    
## To be copied in the UI
# mod_regional_models_ui("regional_models_ui_1")
    
## To be copied in the server
# callModule(mod_regional_models_server, "regional_models_ui_1")
 
