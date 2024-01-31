library(shiny)

ui <- fluidPage(
  
  # text output
  textOutput("text"),
  verbatimTextOutput("code"),
  
  # table output
  tableOutput("static"),
  dataTableOutput("dynamic"),
  
  # plot output
  plotOutput("plot", width = "400px")
  
)

server <- function(input, output, session) {
  
  # text output
  ## renderText() combines the result into a single string, and is usually paired with textOutput()
  output$text <- renderText("Hello friend!")
  
  ## renderPrint() prints the result, as if you were in an R console, and is usually paired with verbatimTextOutput()
  output$code <- renderPrint(summary(1:10))
  
  # table output
  ## tableOutput() and renderTable() render a static table of data, showing all the data at once
  output$static <- renderTable(head(mtcars))
  ## dataTableOutput() and renderDataTable() render a dynamic table, showing a fixed number of rows along with controls to change which rows are visible
  output$dynamic <- renderDataTable(mtcars, options = list(pageLength = 5))
  
  # plot output
  output$plot <- renderPlot(plot(1:5), res = 96)
  
}

shinyApp(ui, server)