# 16.3.4.3. Rewrite your code from the previous answer to eliminate the use of observe()/observeEvent() and only use reactive(). 
# Why can you do that for the second UI but not the first?

library(shiny)

ui <- fluidPage(
  selectInput("type", "type", c("Normal", "Uniform")),
  actionButton("go", "go"),
  plotOutput("plot")
)

server <- function(input, output, session) {
  
  r <- reactive(
    switch(input$type,
           "Normal" = rnorm(100),
           "Uniform" = runif(100)
           )
  )
  
  output$plot <- renderPlot({
    req(input$go)
    isolate(hist(r()))
  })
}

shinyApp(ui, server)

# Because the distribution type is defined with the same input.