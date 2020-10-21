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
      ),#column
      column(width=3,
             radioButtons(ns("xvar"),"variable x",table_regmod$label)
      ),
      column(width=3,
             radioButtons(ns("yvar"),"variable y",table_regmod$label)
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
    x=table_regmod %>% dplyr::filter(label==input$xvar) %>% dplyr::pull(name)
    y=table_regmod %>% dplyr::filter(label==input$yvar) %>% dplyr::pull(name)
    plot_regmod(x,y)
  })
  observeEvent(input$plot_brush,{
    ids=get_rivers_from_scatterplot(table_regmod %>% dplyr::filter(label==input$xvar) %>% dplyr::pull(name),
                                    table_regmod %>% dplyr::filter(label==input$yvar) %>% dplyr::pull(name),
                                   input$plot_brush$xmin,
                                   input$plot_brush$xmax,
                                   input$plot_brush$ymin,
                                   input$plot_brush$ymax)
    map=leaflet::leafletProxy("map",session) %>% 
      leaflet::clearGroup("rivers_in_brush") %>% 
      leaflet::addPolylines(data=datRMCsp %>% subset(idn %in% ids),
                            col="red",
                            group="rivers_in_brush")
  })
}
    
## To be copied in the UI
# mod_regional_models_ui("regional_models_ui_1")
    
## To be copied in the server
# callModule(mod_regional_models_server, "regional_models_ui_1")
 
