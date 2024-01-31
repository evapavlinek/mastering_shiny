library(shiny)

ui <- fluidPage(
  textInput("name", "name"),
  actionButton("add", "add"),
  actionButton("del", "delete"),
  textOutput("names")
)

server <- function(input, output, session) {
  r <- reactiveValues(names = character())
  
  # providing a delete button and making sure that the add button doesn’t create duplicate names
  observeEvent(input$add, {
    r$names <- union(r$names, input$name)
    updateTextInput(session, "name", value = "")
  })
  observeEvent(input$del, {
    r$names <- setdiff(r$names, input$name)
    updateTextInput(session, "name", value = "")
  })
  
  output$names <- renderText(r$names)
}

shinyApp(ui, server)

