# Suppose your friend wants to design an app that allows the user to set a number (x) 
# between 1 and 50, and displays the result of multiplying this number by 5.

library(shiny)

ui <- fluidPage(
  sliderInput("x", label = "If x is", min = 1, max = 50, value = 30),
  "then x times 5 is",
  textOutput("product")
)

server <- function(input, output, session) {
  output$product <- renderText({ 
    input$x * 5
  })
}

shinyApp(ui, server)