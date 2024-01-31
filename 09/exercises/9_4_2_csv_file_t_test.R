# Create an app that lets you upload a csv file, select a variable, and then perform a t.test() on that variable. 
# After the user has uploaded the csv file, you’ll need to use updateSelectInput() to fill in the available variables. 
# See Section 10.1 for details.

library(shiny)

t_test <- function(var) {
  test <- t.test(var)
  
  # use sprintf() to format t.test() results compactly
  sprintf(
    "p value: %0.3f\n[%0.2f, %0.2f]",
    test$p.value, test$conf.int[1], test$conf.int[2]
  )
}


ui <- fluidPage(
  fileInput("upload", NULL, accept = ".csv"),
  selectInput("var", "Select the variable", choices = NULL),
  tableOutput("test")
)

server <- function(input, output, session) {
  
  # read the csv file when the file is uploaded
  data <- reactive({
    req(input$upload)
    vroom::vroom(input$upload$datapath, delim = ",")
  })
  
  # update the possible choices for the selected variable
  observeEvent(input$upload, updateSelectInput(inputId = "var", choices = colnames(data())))
  
  # t-test
  output$test <- renderText({
    req(input$upload)
    t_test(data()[, input$var])
  })
}

shinyApp(ui, server)



# creating test data
# test <- data.frame(
#   a = sample(100),
#   b = sample(100),
#   c = runif(100)
# )
# colnames(test) <- c("sample1", "sample2", "uniform")
# write.csv(test, "C:\\Users\\Eva\\Desktop\\test.csv", row.names = FALSE)
