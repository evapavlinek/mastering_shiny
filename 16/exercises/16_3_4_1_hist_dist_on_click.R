# 16.3.4.1. Provide a server function that draws a histogram of 100 random numbers from a normal distribution when normal is clicked, 
# and 100 random uniforms.

library(shiny)

ui <- fluidPage(
  actionButton("rnorm", "Normal"),
  actionButton("runif", "Uniform"),
  plotOutput("plot")
)

server <- function(input, output, session) {
  r <- reactiveValues(dist = 0)
  observeEvent(input$rnorm, {
    r$dist <- rnorm(100)
  })
  observeEvent(input$runif, {
    r$dist <- runif(100)
  })
  
  output$plot <- renderPlot({
    req(input$rnorm | input$runif)
    hist(r$dist)
  })
}

shinyApp(ui, server)
