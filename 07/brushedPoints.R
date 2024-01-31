library(shiny)

ui <- fluidPage(
  plotOutput("plot", brush = "plot_brush"),
  tableOutput("data")
)

server <- function(input, output, session) {
  output$plot <- renderPlot({
    ggplot(mtcars, aes(wt, mpg)) + geom_point()
  }, res = 96)
  
  output$data <- renderTable({
    brushedPoints(mtcars, input$plot_brush)
  })
}

shinyApp(ui, server)



### adding brush options
brush_opts <- brushOpts(
  id = "plot_brush",
  fill = "green",
  stroke = "darkgrey",
  opacity = 0.4
)


ui <- fluidPage(
  plotOutput("plot", brush = brush_opts),
  tableOutput("data")
)

server <- function(input, output, session) {
  output$plot <- renderPlot({
    ggplot(mtcars, aes(wt, mpg)) + geom_point()
  }, res = 96)
  
  output$data <- renderTable({
    brushedPoints(mtcars, input$plot_brush)
  })
}

shinyApp(ui, server)
