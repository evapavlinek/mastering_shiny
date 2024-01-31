# 19.3.7.3. The following module input provides a text control that lets you type a date in ISO8601 format (yyyy-mm-dd). 
# Complete the module by providing a server function that uses output$error to display a message if the entered value 
# is not a valid date. The module should return a Date object for valid dates. (Hint: use strptime(x, "%Y-%m-%d") to 
# parse the string; it will return NA if the value isn’t a valid date.)

library(shiny)

ymdDateUI <- function(id, label) {
  label <- paste0(label, " (yyyy-mm-dd)")
  
  fluidRow(
    textInput(NS(id, "date"), label),
    textOutput(NS(id, "error"))
  )
}


ymdDateServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$error <- renderPrint({
      req(input$date, cancelOutput = TRUE)
      date <- strptime(input$date, "%Y-%m-%d")

      if (is.na(date)) {
        "The entered date is not in the (yyyy-mm-dd) format!"
        } else {
          as.Date(date)
        }
    })
  })
}
  
  



dateApp <- function() {
  ui <- fluidPage(
    ymdDateUI("date", "Enter the date in the following format:")
  )
    
  server <- function(input, output, session) {
    ymdDateServer("date")
  }
  
  shinyApp(ui, server)
} 

dateApp()

