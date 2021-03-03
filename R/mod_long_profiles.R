# Module UI
  
#' @title   mod_long_profiles_ui and mod_long_profiles_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_long_profiles
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_long_profiles_ui <- function(id){
  ns <- NS(id)
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # List the first level UI elements here 
    # Application title
    fluidPage(
      wellPanel(
       fluidRow(
      column(width=2,
             p("Sélectionner un cours d'eau en cliquant sur la carte.")
             ),#column
      column(width=2,
             uiOutput(ns("ui_zvar"))
            ),
      column(width=2,
             uiOutput(ns("ui_landcover")),
             uiOutput(ns("ui_continuity")),
             uiOutput(ns("ui_historic"))
            )
      )#fluidRow
      ),#wellPanel
      fluidRow(
        column(width=4,
               leaflet::leafletOutput(ns("maplongprof"))
               ),#column
        column(width=8,
               plotOutput(ns("plot"),
                          brush = ns("plot_brush"))
               )#column
      )
    )#fluidPage
  )#tagList
}
    
# Module Server
    
#' @rdname mod_long_profiles
#' @export
#' @keywords internal
    
mod_long_profiles_server <- function(input, output, session){

  ns <- session$ns
  
  output$maplongprof <- leaflet::renderLeaflet({
    mapobj
  })
  
  observeEvent(rget_axis(),{
    river=datsf %>% 
      dplyr::filter(ID==rget_axis())
    print(river)
    map=leaflet::leafletProxy("maplongprof",session) %>%
      leaflet::clearGroup("pouet") %>%
      leaflet::addPolylines(data=river,
                            color="blue",
                            group="pouet")
    map
  })

  observeEvent(input$plot_brush,{
    rect=get_rect_bounds_from_profile(axis=rget_axis(),
                                      input$plot_brush$xmin*1000, 
                                      input$plot_brush$xmax*1000)
    map=leaflet::leafletProxy("maplongprof",session) %>% 
      leaflet::clearGroup("points") %>% 
      leaflet::addRectangles(rect$lng[1],
                             rect$lat[1],
                             rect$lng[2],
                             rect$lat[2],
                             group="points")
  })

  rget_axis=reactive({
    if(is.null(input$maplongprof_shape_click$id)){clickid="AX0001"}else{
      clickid=input$maplongprof_shape_click$id}
    clickid
  })
  
  output$ui_zvar=renderUI({
    axis=rget_axis()
    available_choices=table_metrics %>% 
      dplyr::filter(filename %in% get_available_info(axis),
                    include==1,
                    typelzk=="z") %>% 
      dplyr::pull(varname)
    result=tagList(radioButtons(inputId=ns("zvar"),
                                 label="variable",
                                 choices=available_choices))
    result
  })
  output$ui_landcover=renderUI({
    result=NULL
    req(input$zvar)
    if(stringr::str_detect(input$zvar,"landcover")){
      result=tagList(selectInput(ns("keep_landcovers"),
                                 "Afficher ces types:",
                                 choices=landcovers,
                                 selected=landcovers,
                                 selectize=TRUE,
                                 multiple=TRUE),
                     radioButtons(ns("facet_landcovers"),
                                  "Graphique",
                                  c("Unique","Multiple"))
                      )
    }
    result
  })
  output$ui_continuity=renderUI({
    result=NULL
    req(input$zvar)
    if(stringr::str_detect(input$zvar,"continuity")){
      result=tagList(selectInput(ns("keep_continuities"),
                                 "Afficher ces types:",
                                 choices=continuities,
                                 selected=continuities,
                                 selectize=TRUE,
                                 multiple=TRUE),
                     radioButtons(ns("facet_continuities"),
                                  "Graphique",
                                  c("Unique","Multiple"))
      )
    }
    result
  })
  output$ui_historic=renderUI({
    result=NULL
    req(input$zvar)
    if(stringr::str_detect(input$zvar,"historic")){
      result=tagList(selectInput(ns("keep_landcovers_hist"),
                                 "Afficher ces types:",
                                 choices=landcovers_hist,
                                 selected=landcovers_hist,
                                 selectize=TRUE,
                                 multiple=TRUE)
      )
    }
    result
  })
  
  output$plot=renderPlot({
    info=get_info(axis=rget_axis(),
                  zvar=req(input$zvar)
    )
    if(info$typevar=="landcover"){
      facets=req(input$facet_landcovers)
      keep=req(input$keep_landcovers)
      p=plot_landcover_profiles(info=info,
                                facets=facets,
                                keep=keep)
    }
    if(info$typevar=="continuity"){
      facets=req(input$facet_continuities)
      keep=req(input$keep_continuities)
      p=plot_continuity_profiles(info=info,
                                 facets=facets,
                                 keep=keep)
    }
    if(info$typevar=="historic"){
      keep_landcovers_hist=req(input$keep_landcovers_hist)
      p=plot_historic_profiles(info=info,
                               keep_landcover=keep_landcovers_hist,
                               keep_time=NA)
    }
    
    if(info$typevar=="metrics"){
      p=plot_profiles(info)
    }
    p
  })
}
    
## To be copied in the UI
# mod_long_profiles_ui("long_profiles_ui_1")
    
## To be copied in the server
# callModule(mod_long_profiles_server, "long_profiles_ui_1")
 
