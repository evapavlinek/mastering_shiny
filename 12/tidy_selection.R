library(shiny)
library(dplyr, warn.conflicts = FALSE)

ui <- fluidPage(
  selectInput("vars", "Variables", names(mtcars), multiple = TRUE),
  tableOutput("data")
)

server <- function(input, output, session) {
  output$data <- renderTable({
    req(input$vars)
    mtcars %>% select(all_of(input$vars))
  })
}

shinyApp(ui, server)

