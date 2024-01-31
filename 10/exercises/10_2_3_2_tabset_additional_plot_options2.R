# 10.2.3.2 Create an app that plots ggplot(diamonds, aes(carat)) but allows the user to choose which geom to use: 
# geom_histogram(), geom_freqpoly(), or geom_density(). Use a hidden tabset to allow the user to select different 
# arguments depending on the geom: geom_histogram() and geom_freqpoly() have a binwidth argument; geom_density() has 
# a bw argument.

library(shiny)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput("plot", "Select the plot type", choices = c("histogram", "freqpoly", "density")),
      tabsetPanel(
        id = "params",
        type = "hidden",
        tabPanel("binwidth",
                 sliderInput("binwidth", "Select the binwidth", min = 0.01, max = 3, value = 0.2)
                 ),
        tabPanel("bw",
                 sliderInput("bw", "Select the bandwidth", min = 0.01, max = 1, value = 0.5)
                 )
        )
      ),
    mainPanel(
      plotOutput("plot")
    )
  )
)

server <- function(input, output, session) {
  main.plot <- function() {
    ggplot(diamonds, aes(carat))
  }
  
  observeEvent(input$plot, {
    tab <- ifelse(input$plot == "density", "bw", "binwidth") 
    updateTabsetPanel(inputId = "params", selected = tab)
  })
  
  plot <- reactive({
    switch (input$plot,
            histogram = main.plot() + geom_histogram(fill = "#94b594", binwidth = input$binwidth),
            freqpoly = main.plot() + geom_freqpoly(fill = "#94b594", binwidth = input$binwidth),
            density = main.plot() + geom_density(fill = "#94b594", bw = input$bw)
    )
  })
  
  output$plot <- renderPlot(plot())
}

shinyApp(ui, server)