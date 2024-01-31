# 6.2.4.1. Read the documentation of sidebarLayout() to determine the width (in columns) of the sidebar and the main panel. 
# Can you recreate its appearance using fluidRow() and column()? What are you missing?

?sidebarLayout
# sidebar width = 4
# main panel width = 8 (2/3 of the horizontal width)

?fluidRow

fluidRow(
  column(4, 
         ...
  ), 
  column(8,
         ...
  )
)

# I am missing the title panel



### an example with the sidebar
ui <- fluidPage(
  
  # Application title
  titlePanel("Hello Shiny!"),
  
  sidebarLayout(
    
    # Sidebar with a slider input
    sidebarPanel(
      sliderInput("obs",
                  "Number of observations:",
                  min = 0,
                  max = 1000,
                  value = 500)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
)


# Server logic
server <- function(input, output) {
  output$distPlot <- renderPlot({
    hist(rnorm(input$obs))
  })
}

# Complete app with UI and server components
shinyApp(ui, server)



### an example with the fluidrows
ui <- fluidPage(
  
  # Application title
  fluidRow(
    column(12, "Hello Shiny!")
  ),
  fluidRow(
    column(4, 
           sliderInput("obs",
                       "Number of observations:",
                       min = 0,
                       max = 1000,
                       value = 500)
    ),
    column(8, plotOutput("distPlot"))
  )
)


# Server logic
server <- function(input, output) {
  output$distPlot <- renderPlot({
    hist(rnorm(input$obs))
  })
}

# Complete app with UI and server components
shinyApp(ui, server)
