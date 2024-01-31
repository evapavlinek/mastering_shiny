# 15.2.3.2. Modify the above app to use req() instead of stop(). Verify that events still 
# propagate the same way. What happens when you use the cancelOutput argument?

library(shiny)
library(reactlog)

reactlog_enable()

ui <- fluidPage(
  checkboxInput("error", "error?"),
  textOutput("result")
)

server <- function(input, output, session) {
  a <- reactive({
    req(!input$error)
    #req(!input$error, cancelOutput = TRUE)
    1
  })
  b <- reactive(a() + 1)
  c <- reactive(b() + 1)
  output$result <- renderText(c())
}

shinyApp(ui, server)

shiny::reactlogShow()
