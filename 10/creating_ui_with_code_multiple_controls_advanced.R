library(purrr)
library(shiny)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      numericInput("n", "Number of colours", value = 5, min = 1),
      uiOutput("col"),
    ),
    mainPanel(
      plotOutput("plot")  
    )
  )
)

server <- function(input, output, session) {
  col_names <- reactive(paste0("col", seq_len(input$n)))
  
  output$col <- renderUI({
    # isolate ensures that we don’t create a reactive dependency that would cause this code to re-run every 
    # time input$dynamic changes 
    map(col_names(), ~ textInput(.x, NULL, value = isolate(input[[.x]])))
  })
  
  output$plot <- renderPlot({
    cols <- map_chr(col_names(), ~ input[[.x]] %||% "")
    # convert empty inputs to transparent
    cols[cols == ""] <- NA
    
    barplot(
      rep(1, length(cols)), 
      col = cols,
      space = 0, 
      axes = FALSE
    )
  }, res = 96)
}

shinyApp(ui, server)


# So far we’ve always accessed the components of input with $, e.g. input$col1. 
# But here we have the input names in a character vector, like var <- "col1". 
# $ no longer works in this scenario, so we need to swich to [[, i.e. input[[var]].

# `%||%` function: if input[[.x]] is NULL -> return empty string ""
# input[[.x]] %||% ""
