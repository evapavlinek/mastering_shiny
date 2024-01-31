# 19.2.6.3. The following module generates a new random number every time you click go. 
# Create an app that displays four copies of this module on a single page. Verify that each module is independent. 
# How could you change the return value of randomUI() to make the display more attractive?

library(shiny)

randomUI <- function(id) {
  tagList(
    sidebarLayout(
      sidebarPanel(
        actionButton(NS(id, "go"), "Go!")
        ),
      mainPanel(
        textOutput(NS(id, "val"))
      )
    )
  )
}

randomServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    rand <- eventReactive(input$go, sample(100, 1))
    output$val <- renderText(rand())
  })
}

randomGeneratorApp <- function() {
  ui <- fluidPage(
    randomUI("num1"),
    randomUI("num2"),
    randomUI("num3"),
    randomUI("num4")
  )
  server <- function(input, output, session) {
    randomServer("num1")
    randomServer("num2")
    randomServer("num3")
    randomServer("num4")
  }
  shinyApp(ui, server)
}

randomGeneratorApp()
