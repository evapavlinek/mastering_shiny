# 10.1.6.2 Complete the user interface below with a server function that updates input$county choices based on input$state. 
# For an added challenge, also change the label from “County” to “Parish” for Louisiana and “Borough” for Alaska. 

library(shiny)
library(openintro, warn.conflicts = FALSE)

states <- unique(county$state)

ui <- fluidPage(
  selectInput("state", "State", choices = states),
  selectInput("county", "County", choices = NULL)
)

server <- function(input, output, session) {
  sel_state <- reactive(
    filter(county, state == input$state)
  )
  
  observeEvent(input$state, {
    if (input$state == "Louisiana") {
      updateSelectInput(inputId = "county", label = "Parish")
    } else if (input$state == "Alaska") {
      updateSelectInput(inputId = "county", label = "Borough")
    } else {
      updateSelectInput(inputId = "county", label = "County")
    }
    updateSelectInput(inputId = "county", choices = unique(sel_state()$name))
  })
}

shinyApp(ui, server)