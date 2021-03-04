# Module UI

#' @title   mod_regional_models_ui and mod_regional_models_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_regional_models
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_regional_models_ui <- function(id){
  ns <- NS(id)
  fluidPage(
    fluidRow(
      column(width=3,
             sliderInput(ns("strahler"),
                         label="Afficher rivières de niveau Strahler",
                         min=0,max=7,value=c(5,7),step=1)
      ),#column
      column(width=3,
             radioButtons(ns("xvar"),
                          "variable x",
                          table_regmod$label)
      ),
      column(width=3,
             radioButtons(ns("yvar"),
                          "variable y",
                          table_regmod$label,
                          selected="largeur moyenne de la bande active")
      ),#column
      column(width=3,
             radioButtons(ns("xtrans"),
                          "transfo de x",
                          c("identity","sqrt")),
             radioButtons(ns("ytrans"),
                          "transfo de y",
                          c("identity","sqrt"))
      )#column
    ),#fluidRow
    fluidRow(
      column(width=6,
             leaflet::leafletOutput(ns("mapregmod"))
      ),#column
      column(width=6,
             plotOutput(ns("plot"),
                        brush = ns("plot_brush"))
      )#column
    )
  )#fluidPage
}
    
#' @rdname mod_regional_models
#' @export
#' @keywords internal
mod_regional_models_server <- function(input, output, session){
  ns <- session$ns
  rsubset_spdata <- reactive({
    dat=datRMC %>% 
      dplyr::filter(strahler>=input$strahler[1],
                    strahler<=input$strahler[2]) %>% 
      calc_regmod(x=input$xvar,
                  y=input$yvar,
                  xtrans=input$xtrans,
                  ytrans=input$ytrans)
    dat$data
  })
  
  output$mapregmod <- leaflet::renderLeaflet({
    rivers=rsubset_spdata()
    basic_map() %>% 
      add_rivers_to_map(rivers,
                        group="nobrush",
                        vlayerId="axis",
                        vcolor="relpos",
                        vpopup="TOPONYME")
  })
  
  # observeEvent(rsubset_spdata(),{
  # 
  #   map=leaflet::leafletProxy("mapregmod",session) 
  #   map=map %>%
  #   #leaflet::clearGroup("first_view") %>% 
  # 
  # })
  output$plot <- renderPlot({
    plot_regmod(calc_regmod(rsubset_spdata(),
                            input$xvar,
                            input$yvar,
                            input$xtrans,
                            input$ytrans))
  })
  observeEvent(input$plot_brush,{
    ids=get_rivers_from_scatterplot(table_regmod %>% dplyr::filter(label==input$xvar) %>% dplyr::pull(name),
                                    table_regmod %>% dplyr::filter(label==input$yvar) %>% dplyr::pull(name),
                                    input$plot_brush$xmin,
                                    input$plot_brush$xmax,
                                    input$plot_brush$ymin,
                                    input$plot_brush$ymax,
                                    input$xtrans,
                                    input$ytrans)
    rivers_in_brush=rsubset_spdata() %>%
      dplyr::filter(idn %in% ids)
    map=leaflet::leafletProxy("mapregmod",session) %>% 
      leaflet::clearGroup("rivers_in_brush") %>% 
      add_rivers_to_map(rivers_in_brush,
                        vlayerId="idn",
                        group="rivers_in_brush",
                        color="#00ff00")
  })
}
    
## To be copied in the UI
# mod_regional_models_ui("regional_models_ui_1")
    
## To be copied in the server
# callModule(mod_regional_models_server, "regional_models_ui_1")
 
