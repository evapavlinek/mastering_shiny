# 10_1_6_3 Complete the user interface below with a server function that updates input$country choices based on the 
# input$continent. Use output$data to display all matching rows.

library(shiny)
library(gapminder)

continents <- unique(gapminder$continent)

ui <- fluidPage(
  titlePanel("Let's get some info about the countries!"),
  sidebarLayout(
    sidebarPanel(
      selectInput("continent", "Continent", choices = continents), 
      selectInput("country", "Country", choices = NULL)
    ),
    mainPanel(
      tableOutput("data")
    )
  )
)

server <- function(input, output, session) {
  sel_continent <- reactive(
    filter(gapminder, continent == input$continent)
  )
  
  observeEvent(input$continent, {
    updateSelectInput(inputId = "country", choices = unique(sel_continent()$country))
  })
  
  output$data <- renderTable(filter(sel_continent(), country == input$country))
}

shinyApp(ui, server)

