# 10.2.3.3 Modify the app you created in the previous exercise to allow the user to choose whether each geom is shown 
# or not (i.e. instead of always using one geom, they can picked 0, 1, 2, or 3). Make sure that you can control the 
# binwidth of the histogram and frequency polygon independently.

library(shiny)
library(ggplot2)
library(patchwork)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("plot", "Select the plot type", 
                         choices = c("histogram" = "histogram", 
                                     "freqpoly" = "freqpoly", 
                                     "density" = "density")),
      tabsetPanel(
        id = "params",
        #type = "hidden",
        tabPanel("binwidth",
                 sliderInput("binwidth", "Select the binwidth", min = 0.01, max = 3, value = 0.2)
        ),
        tabPanel("bw",
                 sliderInput("bw", "Select the bandwidth", min = 0.01, max = 1, value = 0.1)
        )
      )
    ),
    mainPanel(
      plotOutput("plots_final"),
      textOutput("selected")
    )
  )
)

server <- function(input, output, session) {
  main.plot <- function() {
    ggplot(diamonds, aes(carat))
  }
  
  # plots
  plot_hist <- reactive({
    if ("histogram" %in% input$plot) {
      main.plot() + geom_histogram(fill = "#94b594", binwidth = input$binwidth)
    }
  })
  plot_freq <- reactive({
    if ("freqpoly" %in% input$plot) {
      main.plot() + geom_freqpoly(binwidth = input$binwidth)
    } 
  })
  plot_den <- reactive({
    if ("density" %in% input$plot) {
      main.plot() + geom_density(fill = "#94b594", bw = input$bw)
    } 
  })
  
  # because patchwork doesn't work if the first plot is NULL
  final_plot <- reactive({
    plot_opts <- c("histogram" = "plot_hist()", 
                   "freqpoly" = "plot_freq()", 
                   "density" = "plot_den()")
    eval(parse(text = paste(unlist(plot_opts[c("histogram", "freqpoly", "density") %in% input$plot]), collapse = "+")))
  })
  
  output$plots_final <- renderPlot({
    final_plot()
    })
  
}

shinyApp(ui, server)
