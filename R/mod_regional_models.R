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
             sliderInput(ns("strahler"),
                         label="Afficher rivières de niveau Strahler",
                         min=0,max=7,value=c(5,7),step=1)
             # radioButtons(ns("selectaxistype"),
             #              label="Choisir un axe",
             #              choices=c("en cliquant sur la carte",
             #                        "depuis un menu déroulant"),
             #              selected="en cliquant sur la carte"),
             # uiOutput(ns("menu"))
             
      ),#column
      column(width=3,
             radioButtons(ns("xvar"),"variable x",tib_regmod$label)
      ),
      column(width=3,
             radioButtons(ns("yvar"),"variable y",tib_regmod$label)
             #uiOutput(ns("selectdescriptor"))
      )#column
    ),#fluidRow
    fluidRow(
      column(width=6,
             leaflet::leafletOutput(ns("map"))
      ),#column
      column(width=6,
             plotOutput(ns("plot"),
                        brush = ns("plot_brush"))
      )#column
    )
  )#fluidPage
}
    
#' regional_models Server Function
#'
#' @noRd 
mod_regional_models_server <- function(input, output, session){
  ns <- session$ns
  rsubset_spdata <- reactive({
    dat=datRMCsp %>% 
      subset(strahler>=input$strahler[1] & strahler<=input$strahler[2])
    dat
  })
  
  output$map <- leaflet::renderLeaflet({
    basic_map() %>% 
    leaflet::addPolylines(data=datRMCsp %>% 
                          subset(strahler>=input$strahler[1] & strahler<=input$strahler[2]),
                          group="first_view")
  })
  
  observeEvent(rsubset_spdata(),{
    spdat=rsubset_spdata()
    map=leaflet::leafletProxy("map",session) %>%
    leaflet::clearGroup("first_view") %>% 
    add_rivers_to_map(spdat)
  })
  output$plot <- renderPlot({
    x=tib_regmod %>% dplyr::filter(label==input$xvar) %>% dplyr::pull(nom)
    y=tib_regmod %>% dplyr::filter(label==input$yvar) %>% dplyr::pull(nom)
    plot_regmod(x,y)
  })
  observeEvent(input$plot_brush,{
    bounds=get_rect_bounds(rget_axis(),input$plot_brush$xmin, input$plot_brush$xmax)
    map=leaflet::leafletProxy("map",session) %>% 
      leaflet::clearGroup("points") %>% 
      leaflet::addRectangles(bounds$lng[1],
                             bounds$lat[1],
                             bounds$lng[2],
                             bounds$lat[2], 
                             group="points")
  })
}
    
## To be copied in the UI
# mod_regional_models_ui("regional_models_ui_1")
    
## To be copied in the server
# callModule(mod_regional_models_server, "regional_models_ui_1")
 
