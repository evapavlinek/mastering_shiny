# 10.3.5.2. Explain how this app works. Why does the password disappear when you click the enter password button a second time?

library(shiny)

ui <- fluidPage(
  actionButton("go", "Enter password"),
  textOutput("text")
)

server <- function(input, output, session) {
  observeEvent(input$go, {
    showModal(modalDialog(
      passwordInput("password", NULL),
      title = "Please enter your password"
    ))
  })
  
  output$text <- renderText({
    if (!isTruthy(input$password)) {
      "No password"
    } else {
      "Password entered"
    }
  })
}

shinyApp(ui, server)


# the password is not saved anywhere in the app