# Create an app that lets the user upload a csv file, select one variable, draw a histogram, and then download the histogram. 
# For an additional challenge, allow the user to select from .png, .pdf, and .svg output formats.

library(shiny)
library(ggplot2)

ui <- fluidPage(
  fileInput("upload", NULL, accept = ".csv"),
  selectInput("var", "Select the variable", choices = NULL),
  sliderInput("n", "Select the number of bins", min = 1, max = 100, value = 10),
  plotOutput("plot"),
  selectInput("format", "Select the format", choices = c("png", "pdf", "svg")),
  downloadButton("download", "Download the image")
)

server <- function(input, output, session) {
  
  # read the csv file when the file is uploaded
  data <- reactive({
    req(input$upload)
    as.data.frame(vroom::vroom(input$upload$datapath))
  })
  
  n <- reactive(input$n)
  
  # update the possible choices for the selected variable
  observeEvent(input$upload, updateSelectInput(inputId = "var", choices = colnames(data())))
  sel_data <- reactive(data.frame(var = data()[, input$var]))
  
  # plot
  plot <- reactive({
    req(input$upload)
    ggplot(sel_data(), aes(var)) +
      geom_histogram(bins = n(), fill = "lightblue", colour = "black") + 
      xlab(input$var)
  })
  
  output$plot <- renderPlot(plot())
  
  output$download <- downloadHandler(
    filename = function() {
      paste0("histogram.", input$format)
    },
    content = function(file) {
      ggsave(filename = file, plot = plot())
    }
  )
  
}

shinyApp(ui, server)



# creating test data
# test <- data.frame(
#   a = sample(1000),
#   b = sample(1000),
#   c = runif(1000),
#   d = rpois(1000, 7),
#   e = rnorm(1000)
# )
# colnames(test) <- c("sample1", "sample2", "uniform", "pois", "norm")
# write.csv(test, "C:\\Users\\Eva\\Desktop\\test.csv", row.names = FALSE)


