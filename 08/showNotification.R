library(shiny)

ui <- fluidPage(
  actionButton("goodnight", "Good night")
)

# server <- function(input, output, session) {
#   observeEvent(input$goodnight, {
#     showNotification("So long")
#     Sys.sleep(1)
#     showNotification("Farewell")
#     Sys.sleep(1)
#     showNotification("Auf Wiedersehen")
#     Sys.sleep(1)
#     showNotification("Adieu")
#   })
# }

server <- function(input, output, session) {
  observeEvent(input$goodnight, {
    showNotification("So long")
    Sys.sleep(1)
    showNotification("Farewell", type = "message")
    Sys.sleep(1)
    showNotification("Auf Wiedersehen", type = "warning")
    Sys.sleep(1)
    showNotification("Adieu", type = "error")
  })
}

shinyApp(ui, server)