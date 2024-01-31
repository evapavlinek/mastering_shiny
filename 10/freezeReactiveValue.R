# it’s actually good practice to always use it when you dynamically change an input value. 
# The actual modification takes some time to flow to the browser then back to Shiny, and in the 
# interim any reads of the value are at best wasted, and at worst lead to errors. 
# Use freezeReactiveValue() to tell all downstream calculations that an input value is stale and 
# they should save their effort until it’s useful.

ui <- fluidPage(
  selectInput("dataset", "Choose a dataset", c("pressure", "cars")),
  selectInput("column", "Choose column", character(0)),
  verbatimTextOutput("summary")
)

server <- function(input, output, session) {
  dataset <- reactive(get(input$dataset, "package:datasets"))
  
  observeEvent(input$dataset, {
    # This ensures that any reactives or outputs that use the input won’t be updated until the next full round of invalidation
    freezeReactiveValue(input, "column")
    updateSelectInput(inputId = "column", choices = names(dataset()))
  })
  
  output$summary <- renderPrint({
    summary(dataset()[[input$column]])
  })
}

shinyApp(ui, server)