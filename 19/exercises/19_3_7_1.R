# 19.3.7.1. Rewrite selectVarServer() so that both data and filter are reactive. Then use it with an app function that lets the user pick the dataset 
# with the dataset module and filtering function using inputSelect(). Give the user the ability to filter numeric, character, or factor variables.

library(shiny)

datasetInput <- function(id, filter) {
  names <- ls("package:datasets")
  data <- lapply(names, get, "package:datasets")
  names <- names[vapply(data, filter, logical(1))]
  
  selectInput(NS(id, "dataset"), "Pick a dataset", choices = names)
}


selectFilterInput <- function(id) {
  selectInput(NS(id, "filter"), "Variable type", choices = c("is.numeric", "is.character", "is.factor")) 
}

selectVarInput <- function(id) {
  selectInput(NS(id, "var"), "Variable", choices = NULL) 
}


histogramOutput <- function(id) {
  tagList(
    numericInput(NS(id, "bins"), "bins", 10, min = 1, step = 1),
    plotOutput(NS(id, "hist"))
  )
}



datasetServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    reactive(get(input$dataset, "package:datasets"))
  })
}

# filterServer <- function(id) {
#   moduleServer(id, function(input, output, session) {
#     reactive(input$filter)
#   })
# }

# a helper function
find_vars <- function(data, filter) {
  stopifnot(is.data.frame(data))
  stopifnot(is.function(filter))
  names(data)[vapply(data, filter, logical(1))]
}

selectVarServer <- function(id, data, filter) {
  stopifnot(is.reactive(data))
  stopifnot(is.reactive(filter))
  
  moduleServer(id, function(input, output, session) {
    observeEvent(data(), {
      updateSelectInput(session, "var", choices = find_vars(data(), filter))
    })
    
    list(
      name = reactive(input$var),
      value = reactive(data()[[input$var]])
    )
  })
}

histogramServer <- function(id, x, title = reactive("Histogram")) {
  stopifnot(is.reactive(x))
  stopifnot(is.reactive(title))
  
  moduleServer(id, function(input, output, session) {
    output$hist <- renderPlot({
      req(is.numeric(x()))
      main <- paste0(title(), " [", input$bins, "]")
      hist(x(), breaks = input$bins, main = main)
    }, res = 96)
  })
}


histogramApp <- function() {
  ui <- fluidPage(
    sidebarLayout(
      sidebarPanel(
        datasetInput("data", is.data.frame), # sta s ovim is.data.frame?
        selectFilterInput("filter"), 
        selectVarInput("var"),
      ),
      mainPanel(
        histogramOutput("hist")    
      )
    )
  )
  
  server <- function(input, output, session) {
    data <- datasetServer("data")
    filter <- reactive(selectFilterInput("filter"))
    x <- selectVarServer("var", data, filter)
    histogramServer("hist", x$value, x$name)
  }
  
  shinyApp(ui, server)
}


histogramApp()
