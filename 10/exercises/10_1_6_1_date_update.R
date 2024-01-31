# 10.1.6.1. Complete the user interface below with a server function that updates input$date so that 
# you can only select dates in input$year.

library(shiny)

ui <- fluidPage(
  numericInput("year", "year", value = 2020),
  dateInput("date", "date")
)

server <- function(input, output, session) {
  observeEvent(input$year, 
    updateDateInput(inputId = "date", value = input$year,
                    min = paste0(input$year, "-01-01"), max = paste0(input$year, "-12-31"))
  )
  
}

shinyApp(ui, server)