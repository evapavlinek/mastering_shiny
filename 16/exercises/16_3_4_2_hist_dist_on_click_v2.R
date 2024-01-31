# 16.3.4.2. Modify your code from above for to work with this UI:

library(shiny)

ui <- fluidPage(
  selectInput("type", "type", c("Normal", "Uniform")),
  actionButton("go", "go"),
  plotOutput("plot")
)

server <- function(input, output, session) {
  r <- reactiveValues(dist = 0)
  observeEvent(input$type, {
    r$dist <- switch(input$type,
                     "Normal" = rnorm(100), 
                     "Uniform" = runif(100)
                     )
  })
  
  output$plot <- renderPlot({
    req(input$go)
    isolate(hist(r$dist))
  })
}

shinyApp(ui, server)
