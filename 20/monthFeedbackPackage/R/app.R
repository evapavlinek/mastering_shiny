library(shiny)

monthApp <- function(...) {
  #stones <- vroom::vroom("birthstones.csv")
  months <- c(
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
  )
  # stones <- data.frame(month = months,
  #                      stone = 1:12)
  
  ui <- navbarPage(
    "Sample app",
    tabPanel("Pick a month",
             selectInput("month", "What's your favourite month?", choices = months)
    ),
    tabPanel("Feedback", monthFeedbackUI("tab1")),
    tabPanel("Birthstone", birthstoneUI("tab2"))
  )
  server <- function(input, output, session) {
    monthFeedbackServer("tab1", reactive(input$month))
    birthstoneServer("tab2", reactive(input$month))
  }
  shinyApp(ui, server, ...)
}