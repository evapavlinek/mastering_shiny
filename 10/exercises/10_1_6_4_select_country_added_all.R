# 10_1_6_4 Extend the previous app so that you can also choose to select all continents, and hence see all countries. 
# You’ll need to add "(All)" to the list of choices, and then handle that specially when filtering.

library(shiny)
library(gapminder)

continents <- unique(gapminder$continent)

ui <- fluidPage(
  titlePanel("Let's get some info about the countries!"),
  sidebarLayout(
    sidebarPanel(
      selectInput("continent", "Continent", choices = c("All", as.character(continents))), 
      selectInput("country", "Country", choices = NULL)
    ),
    mainPanel(
      tableOutput("data")
    )
  )
)

server <- function(input, output, session) {
  sel_continent <- reactive({
    if (input$continent == "All") {
      gapminder
    } else {
      filter(gapminder, continent == input$continent)
    } 
  })
  
  observeEvent(input$continent, {
    if (input$continent == "All") {
      updateSelectInput(inputId = "country", choices = NULL)
    } else {
      updateSelectInput(inputId = "country", choices = unique(sel_continent()$country))
    }
  })
  
  output$data <- renderTable(
    if (input$continent == "All") {
      sel_continent()
    } else {
      filter(sel_continent(), country == input$country)
    }
  )
}

shinyApp(ui, server)

