library(shiny)
library(testthat) # >= 3.0.0
library(shinytest)

ui <- fluidPage(
  radioButtons("fruit", "What's your favourite fruit?",
               choiceNames = list(
                 "apple", 
                 "pear", 
                 textInput("other", label = NULL, placeholder = "Other")
               ),
               choiceValues = c("apple", "pear", "other")
  ), 
  textOutput("value")
)

server <- function(input, output, session) {
  observeEvent(input$other, ignoreInit = TRUE, {
    updateRadioButtons(session, "fruit", selected = "other")
  })
  
  output$value <- renderText({
    if (input$fruit == "other") {
      req(input$other)
      input$other
    } else {
      input$fruit
    }
  })
}


# Do we get the correct value after setting fruit to an existing option? 
# And do we get the correct value after setting fruit to other and adding some free text?
test_that("returns other value when primary is other", {
  testServer(server, {
    session$setInputs(fruit = "apple")
    expect_equal(output$value, "apple")
    
    session$setInputs(fruit = "other", other = "orange")
    expect_equal(output$value, "orange")
  })  
})

# That doesn’t check that other is automatically selected when we start typing in the other box. 
# We can’t test that using testServer() because it relies on updateRadioButtons() -  we need to use ShinyDriver
test_that("automatically switches to other", {
  app <- ShinyDriver$new(shinyApp(ui, server))
  app$setInputs(other = "orange")
  expect_equal(app$getValue("fruit"), "other")
  expect_equal(app$getValue("value"), "orange")
})


