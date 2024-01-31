# 10.2.3.1 Use a hidden tabset to show additional controls only if the user checks an “advanced” check box.

library(shiny)
library(ggplot2)
library(MetBrewer)

colours <- unlist(MetPalettes$Hokusai[1])

parameter_tabs <- tabsetPanel(
  id = "params",
  type = "hidden",
  tabPanel("normal",
           numericInput("mean", "mean", value = 1),
           numericInput("sd", "standard deviation", min = 0, value = 1)
           ),
  tabPanel("uniform", 
           numericInput("min", "min", value = 0),
           numericInput("max", "max", value = 1)
           ),
  tabPanel("exponential",
           numericInput("rate", "rate", value = 1, min = 0)
           ),
  tabPanel("additional_opts",
           selectInput("colour", "Colour", choices = c("white", colours)),
           textInput("x", "x-axis label", "sample"),
           textInput("y", "y-axis label", "count"),
           textInput("title", "title")
           )
)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput("dist", "Distribution", 
                  choices = c("normal", "uniform", "exponential")
      ),
      numericInput("n", "Number of samples", value = 100),
      parameter_tabs, 
      checkboxInput("advanced", "Advanced")
    ),
    mainPanel(
      plotOutput("hist")
    )
  )
)

server <- function(input, output, session) {
  observeEvent(input$dist, {
    updateTabsetPanel(inputId = "params", selected = input$dist)
  }) 
  
  sample <- reactive({
    switch(input$dist,
           normal = rnorm(input$n, input$mean, input$sd),
           uniform = runif(input$n, input$min, input$max),
           exponential = rexp(input$n, input$rate)
    )
  })
  
  plot <- reactive({
    ggplot(data.frame(sample = sample()), aes(sample)) +
      geom_histogram(fill = input$colour, colour = "black") +
      labs(title = input$title, x = input$x, y = input$y)
  })
  
  output$hist <- renderPlot(plot())
  
  observeEvent(input$advanced, {
    if (input$advanced) {
      updateTabsetPanel(inputId = "params", selected = "additional_opts")
    } else {
      updateTabsetPanel(inputId = "params", selected = input$dist)
    }
  })
  
}

shinyApp(ui, server)




