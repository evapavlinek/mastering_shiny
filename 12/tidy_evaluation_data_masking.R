library(shiny)
library(dplyr, warn.conflicts = FALSE)
library(ggplot2)

num_vars <- c("carat", "depth", "table", "price", "x", "y", "z")

ui <- fluidPage(
  selectInput("var", "Variable", choices = num_vars),
  numericInput("min", "Minimum", value = 1),
  tableOutput("output")
)

server <- function(input, output, session) {
  data <- reactive(diamonds %>% filter(.data[[input$var]] > .env$input$min))
  output$output <- renderTable(head(data()))
}

shinyApp(ui, server)