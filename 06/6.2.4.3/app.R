# 6.2.4.3 Create an app that contains two plots, each of which takes up half of the width. Put the controls in a full width container below 
# the plots.

library(shiny)
library(ggplot2)

ui <- fluidPage(
  fluidRow(
    column(6, plotOutput("plot1")),
    column(6, plotOutput("plot2"))
  ),
  fluidRow(
    column(12, 
            sliderInput("x", "x", min = 2, max = 100, value = 5, step = 10, animate = T),
            sliderInput("y", "y", min = 2, max = 1000, value = 100)
           )
  ),
)

server <- function(input, output, session) {
  x <- reactive(input$x)  
  y <- reactive(input$y)  
  
  output$plot1 <- renderPlot({
    ggplot(data.frame(x = rnorm(x())), aes(x)) + geom_density()
  })
  output$plot2 <- renderPlot({
    ggplot(data.frame(y = rnorm(y())), aes(y)) + geom_density()
  })
}

shinyApp(ui, server)




### with sidebar layout?
ui <- fluidPage(
  fluidRow(
    column(6, plotOutput("plot1")),
    column(6, plotOutput("plot2"))
  ),
  sidebarLayout(
    sidebarPanel(
      sliderInput("x", "x", min = 2, max = 100, value = 5, step = 10, animate = T),
      width = 6
    ),
    mainPanel(
      sliderInput("y", "y", min = 2, max = 1000, value = 100),
      width = 6
    )
  )
)

server <- function(input, output, session) {
  x <- reactive(input$x)  
  y <- reactive(input$y)  
  
  output$plot1 <- renderPlot({
    ggplot(data.frame(x = rnorm(x())), aes(x)) + geom_density()
  })
  output$plot2 <- renderPlot({
    ggplot(data.frame(y = rnorm(y())), aes(y)) + geom_density()
  })
}

shinyApp(ui, server)