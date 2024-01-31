# 10.3.5.3. In the app in Section 10.3.1, what happens if you drop the isolate() from value <- isolate(input$dynamic)?

library(shiny)

ui <- fluidPage(
  textInput("label", "label"),
  selectInput("type", "type", c("slider", "numeric")),
  uiOutput("numeric")
)

server <- function(input, output, session) {
  output$numeric <- renderUI({
    
    # value <- isolate(input$dynamic)
    # if (input$type == "slider") {
    #   sliderInput("dynamic", input$label, value = value, min = 0, max = 10)
    # } else {
    #   numericInput("dynamic", input$label, value = value, min = 0, max = 10)
    # }
    
    if (input$type == "slider") {
      sliderInput("dynamic", input$label, value = 0, min = 0, max = 10)
    } else {
      numericInput("dynamic", input$label, value = 0, min = 0, max = 10)
    }
  })
}

shinyApp(ui, server)

# the value of the slider/numeric input always resets to 0 without the isolate
