library(shiny)
library(ggplot2)

ui <- fluidPage(
  selectInput("x", "X variable", choices = names(iris)),
  selectInput("y", "Y variable", choices = names(iris)),
  plotOutput("plot")
)

server <- function(input, output, session) {
  output$plot <- renderPlot({
    ggplot(iris, aes(.data[[input$x]], .data[[input$y]])) +
      # used ggforce::position_auto() so that geom_point() works nicely regardless of whether 
      # the x and y variables are continuous or discrete
      geom_point(position = ggforce::position_auto())
  }, res = 96)
}

shinyApp(ui, server)


# an alternative
ui <- fluidPage(
  selectInput("x", "X variable", choices = names(iris)),
  selectInput("y", "Y variable", choices = names(iris)),
  selectInput("geom", "geom", c("point", "smooth", "jitter")),
  plotOutput("plot")
)

server <- function(input, output, session) {
  plot_geom <- reactive({
    switch(input$geom,
           point = geom_point(),
           smooth = geom_smooth(se = FALSE),
           jitter = geom_jitter()
    )
  })
  
  output$plot <- renderPlot({
    ggplot(iris, aes(.data[[input$x]], .data[[input$y]])) +
      plot_geom()
  }, res = 96)
}

shinyApp(ui, server)
