# When space is at a premium, it’s useful to label text boxes using a placeholder that 
# appears inside the text entry area.

library(shiny)

ui <- fluidPage(
  textInput("name", "", value = "Your name")
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)