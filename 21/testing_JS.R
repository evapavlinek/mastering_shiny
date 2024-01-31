library(shiny)
library(testthat) # >= 3.0.0
library(shinytest)

ui <- fluidPage(
  textInput("name", "What's your name"),
  textOutput("greeting"),
  actionButton("reset", "Reset")
)

server <- function(input, output, session) {
  output$greeting <- renderText({
    req(input$name)
    paste0("Hi ", input$name)
  })
  observeEvent(input$reset, updateTextInput(session, "name", value = ""))
}


app <- shinytest::ShinyDriver$new(shinyApp(ui, server))
app$setInputs(name = "Hadley")
app$getValue("greeting")
app$click("reset")
app$getValue("greeting")



test_that("can set and reset name", {
  app <- shinytest::ShinyDriver$new(shinyApp(ui, server))
  app$setInputs(name = "Hadley")
  expect_equal(app$getValue("greeting"), "Hi Hadley")
  
  app$click("reset")
  expect_equal(app$getValue("greeting"), "")
})
