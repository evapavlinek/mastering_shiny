# Update the options in the call to renderDataTable() below so that the data is displayed, 
# but all other controls are suppress (i.e. remove the search, ordering, and filtering commands).

library(shiny)

ui <- fluidPage(
  dataTableOutput("table")
)

server <- function(input, output, session) {
  output$table <- renderDataTable(mtcars, 
                                  options = list(
                                    pageLength = 5,
                                    ordering = FALSE,
                                    searching = FALSE))
}

shinyApp(ui, server)