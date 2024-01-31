# 11.3.2 Make a simple app that lets you upload a csv file and then bookmark it. Upload a few files 
# and then look in shiny_bookmarks. How do the files correspond to the bookmarks? (Hint: you can use 
# readRDS() to look inside the cache files that Shiny is generating).

library(shiny)

t_test <- function(var) {
  test <- t.test(var)
  
  # use sprintf() to format t.test() results compactly
  sprintf(
    "p value: %0.3f\n[%0.2f, %0.2f]",
    test$p.value, test$conf.int[1], test$conf.int[2]
  )
}


ui <- function(request) {
  fluidPage(
    fileInput("upload", NULL, accept = ".csv"),
    selectInput("var", "Select the variable", choices = NULL),
    tableOutput("test"),
    bookmarkButton()
    )
}

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

shinyApp(ui, server, enableBookmarking = "server")


# http://127.0.0.1:3574/?_state_id_=5b476fbdfcf4acb1
# http://127.0.0.1:3574/?_state_id_=aa04aa617ff9ad27

readRDS("./shiny_bookmarks/5b476fbdfcf4acb1/input.rds")
readRDS("./shiny_bookmarks/aa04aa617ff9ad27/input.rds")