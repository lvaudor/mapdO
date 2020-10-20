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
    fluidRow(
      column(width=6,
             radioButtons(ns("selectaxistype"),
                          label="Choisir un axe",
                          choices=c("en cliquant sur la carte",
                                    "depuis un menu déroulant"),
                          selected="en cliquant sur la carte"),
             uiOutput(ns("menu"))

             ),#column
      column(width=6,
             uiOutput(ns("selectdescriptor"))
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
  )
}
    
# Module Server
    
#' @rdname mod_long_profiles
#' @export
#' @keywords internal
    
mod_long_profiles_server <- function(input, output, session){

  ns <- session$ns
  output$map <- leaflet::renderLeaflet({
    basic_map() %>% 
    add_rivers_to_map(datsp)
  })
  
  observeEvent(rget_axis(),{
    datsp=datsf %>% sf::as_Spatial()
    ind=which(datsp$axis==rget_axis())
    map=leaflet::leafletProxy("map",session) %>%
      leaflet::clearGroup("pouet") %>%
      leaflet::addPolylines(data=datsp[ind,],color="red",group="pouet")
    map
  })
  output$selectdescriptor=renderUI({
    rget_axis()
    tagList(radioButtons(ns("yvar"),
                         label="Choisir une métrique",
                         choices=tibcorr$type))
  })
  
  output$menu=renderUI({
    if(input$selectaxistype=="depuis un menu déroulant"){
      result=selectInput(ns("axisselect"),
                         "choix d'un axe",
                         datsf$toponyme %>% as.vector(),
                         selected=datsf %>%
                          dplyr::group_by(toponyme) %>%
                          dplyr::summarise(n=dplyr::n()) %>%
                          dplyr::slice_max(n) %>%
                          dplyr::pull(toponyme) %>%
                          as.vector())
    }else{result=NULL}
    result
    })

      
  observeEvent(input$plot_brush,{
    rect=get_rect_bounds(rget_axis(),input$plot_brush$xmin, input$plot_brush$xmax)
    map=leaflet::leafletProxy("map",session) %>% 
      leaflet::clearGroup("points") %>% 
      leaflet::addRectangles(rect$lng[1],
                             rect$lat[1],
                             rect$lng[2],
                             rect$lat[2], group="points")
  })
  rget_clickmap=eventReactive(input$map_shape_click,{input$map_shape_click$id})
  rget_axis=reactive({
    if(input$selectaxistype=="en cliquant sur la carte"){result=rget_clickmap()}
    if(input$selectaxistype=="depuis un menu déroulant"){
      if(is.null(input$axisselect)){myaxis=1}else{myaxis=input$axisselect}
      result=datsf %>% 
        dplyr::filter(as.vector(toponyme)==myaxis) %>% 
        sf::st_drop_geometry() %>% 
        dplyr::group_by(axis) %>%
        dplyr::summarise(n=dplyr::n())%>% 
        dplyr::slice_max(order_by=n,n=1) %>% 
        dplyr::pull(axis)
    }
    result
  })
  rget_data=reactive({get_data(axis=rget_axis(),
                               y=input$yvar)})

  output$plot=renderPlot({
    tib=req(rget_data())
    plot_profiles(tib,input$yvar)
  })
}
    
## To be copied in the UI
# mod_long_profiles_ui("long_profiles_ui_1")
    
## To be copied in the server
# callModule(mod_long_profiles_server, "long_profiles_ui_1")
 
