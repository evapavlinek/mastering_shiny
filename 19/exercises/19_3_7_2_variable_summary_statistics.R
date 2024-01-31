# 19.3.7.2. The following code defines output and server components of a module that takes a numeric input and produces a bulleted 
# list of three summary statistics. Create an app function that allows you to experiment with it. 
# The app function should take a data frame as input, and use numericVarSelectInput() to pick the variable to summarise.
library(shiny)

datasetInput <- function(id) {
  names <- ls("package:datasets")
  data <- lapply(names, get, "package:datasets")
  names <- names[vapply(data, is.data.frame, logical(1))]
  
  selectInput(NS(id, "dataset"), "Pick a dataset", choices = names)
}


numericVarSelectInput <- function(id) {
  selectInput(NS(id, "var"), "Variable", choices = NULL) 
}


# a helper function
find_vars <- function(data, filter) {
  stopifnot(is.data.frame(data))
  stopifnot(is.function(filter))
  names(data)[vapply(data, filter, logical(1))]
}

numericVarSelectServer <- function(id, data) {
  stopifnot(is.reactive(data))
  
  moduleServer(id, function(input, output, session) {
    observeEvent(data(), {
      updateSelectInput(session, "var", choices = find_vars(data(), is.numeric))
    })
    
    reactive(data()[[input$var]])
  })
}


summaryOutput <- function(id) {
  tags$ul(
    tags$li("Min: ", textOutput(NS(id, "min"), inline = TRUE)),
    tags$li("Max: ", textOutput(NS(id, "max"), inline = TRUE)),
    tags$li("Missing: ", textOutput(NS(id, "n_na"), inline = TRUE))
  )
}


datasetServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    reactive(get(input$dataset, "package:datasets"))
  })
}


summaryServer <- function(id, var) {
  moduleServer(id, function(input, output, session) {
    rng <- reactive({
      req(var())
      range(var(), na.rm = TRUE)
    })
    
    output$min <- renderText(rng()[[1]])
    output$max <- renderText(rng()[[2]])
    output$n_na <- renderText(sum(is.na(var())))
  })
}



summaryStatisticsApp <- function() {
  ui <- fluidPage(
    sidebarLayout(
      sidebarPanel(
        datasetInput("data"),
        numericVarSelectInput("var"),
      ),
      mainPanel(
        summaryOutput("summary")    
      )
    )
  )
  
  server <- function(input, output, session) {
    data <- datasetServer("data")
    x <- numericVarSelectServer("var", data)
    summaryServer("summary", x)
  }
  
  shinyApp(ui, server)
} 

summaryStatisticsApp()
