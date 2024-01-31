# The following app is very similar to one you’ve seen earlier in the chapter: 
# you select a dataset from a package (this time we’re using the ggplot2 package) and 
# the app prints out a summary and plot of the data. It also follows good practice and 
# makes use of reactive expressions to avoid redundancy of code. 

library(shiny)
library(ggplot2)

datasets <- c("economics", "faithfuld", "seals")

ui <- fluidPage(
  selectInput("dataset", "Dataset", choices = datasets),
  verbatimTextOutput("summary"),
  plotOutput("plot")
)

server <- function(input, output, session) {
  
  dataset <- reactive({
    get(input$dataset, "package:ggplot2")
  })
  
  output$summary <- renderPrint({
    summary(dataset())
  })
  
  output$plot <- renderPlot({
    plot(dataset())
  }, res = 96)
  
}

shinyApp(ui, server)