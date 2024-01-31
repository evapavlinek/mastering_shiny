library(purrr)
library(shiny)

ui <- fluidPage(
  numericInput("n", "Number of colours", value = 5, min = 1),
  uiOutput("col"),
  textOutput("palette")
)

server <- function(input, output, session) {
  col_names <- reactive(paste0("col", seq_len(input$n)))
  
  output$col <- renderUI({
    map(col_names(), ~ textInput(.x, NULL))
  })
  
  output$palette <- renderText({
    map_chr(col_names(), ~ input[[.x]] %||% "")
  })
}

shinyApp(ui, server)


# So far we’ve always accessed the components of input with $, e.g. input$col1. 
# But here we have the input names in a character vector, like var <- "col1". 
# $ no longer works in this scenario, so we need to swich to [[, i.e. input[[var]].

# `%||%` function: if input[[.x]] is NULL -> return empty string ""
# input[[.x]] %||% ""
