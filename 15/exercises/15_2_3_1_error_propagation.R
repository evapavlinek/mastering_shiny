# 15.2.3.1. Use the reactlog package to observe an error propagating through the reactives in 
# the following app, confirming that it follows the same rules as value propagation.

library(shiny)
library(reactlog)

reactlog_enable()

ui <- fluidPage(
  checkboxInput("error", "error?"),
  textOutput("result")
)

server <- function(input, output, session) {
  a <- reactive({
    if (input$error) {
      stop("Error!")
    } else {
      1
    }
  })
  b <- reactive(a() + 1)
  c <- reactive(b() + 1)
  output$result <- renderText(c())
}

shinyApp(ui, server)

shiny::reactlogShow()
