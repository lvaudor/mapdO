#' test UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#' @export
#' @importFrom shiny NS tagList 
mod_test_ui <- function(id){
  ns <- NS(id)
  tagList(
    verbatimTextOutput(ns("info"))
  )
}
    
#' test Server Function
#' @export
#' @noRd 
mod_test_server <- function(input, output, session){
  ns <- session$ns
  output$info=renderPrint({
    print(input)
  })
}
    
## To be copied in the UI
# mod_test_ui("test_ui_1")
    
## To be copied in the server
# callModule(mod_test_server, "test_ui_1")
 
