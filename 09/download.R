library(shiny)

ui <- fluidPage(
  downloadButton("download1"),
  downloadLink("download2")
)

server <- function(input, output, session) {
  output$download <- downloadHandler(
    filename = function() {
      paste0(input$dataset, ".csv")
    },
    content = function(file) {
      write.csv(data(), file)
    }
  )
}

shinyApp(ui, server)