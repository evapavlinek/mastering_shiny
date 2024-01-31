# 15.4.3.1. Complete the app below with a server function that updates out with the value of x 
# only when the button is pressed.

library(shiny)

ui <- fluidPage(
  numericInput("x", "x", value = 50, min = 0, max = 100),
  actionButton("capture", "capture"),
  textOutput("out")
)

server <- function(input, output, session) {
  num <- eventReactive(input$capture, input$x)
  output$out <- renderText({
    num()
  })
}

shinyApp(ui, server)
