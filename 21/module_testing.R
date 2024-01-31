library(shiny)
library(testthat) # >= 3.0.0
library(shinytest)

summaryUI <- function(id) {
  tagList(
    outputText(ns(id, "min")),
    outputText(ns(id, "mean")),
    outputText(ns(id, "max")),
  )
}

summaryServer <- function(id, var) {
  stopifnot(is.reactive(var))
  
  moduleServer(id, function(input, output, session) {
    range_val <- reactive(range(var(), na.rm = TRUE))
    output$min <- renderText(range_val()[[1]])
    output$max <- renderText(range_val()[[2]])
    output$mean <- renderText(mean(var()))
  })
}


x <- reactiveVal(1:10)
testServer(summaryServer, args = list(var = x), {
  print(range_val())
  print(output$min)
})


test_that("output updates when reactive input changes", {
  x <- reactiveVal()
  testServer(summaryServer, args = list(var = x), {
    x(1:10)
    # because x is created outside of testServer(), changing x does not automatically update the reactive graph, 
    # so we have to do so manually by calling session$flushReact()
    session$flushReact()
    expect_equal(range_val(), c(1, 10))
    expect_equal(output$mean, "5.5")
    
    x(10:20)
    session$flushReact()
    expect_equal(range_val(), c(10, 20))
    expect_equal(output$min, "10")
  }) 
})



# if a module has a return value (a reactive or list of reactives), capture it with session$getReturned()
datasetServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    reactive(get(input$dataset, "package:datasets"))
  })
}

test_that("can find dataset", {
  testServer(datasetServer, {
    dataset <- session$getReturned()
    
    session$setInputs(dataset = "mtcars")
    expect_equal(dataset(), mtcars)
    
    session$setInputs(dataset = "iris")
    expect_equal(dataset(), iris)
  })
})

