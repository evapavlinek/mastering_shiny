# 10.3.5.1. Take the very simple app based on the initial example in the section - How could you instead implement it 
# using dynamic visibility? If you implement dynamic visibility, how could you keep the values in sync when you change 
# the controls?

library(shiny)

ui <- fluidPage(
  selectInput("type", "type", c("slider", "numeric")),
  tabsetPanel(
    id = "switch",
    type = "hidden", 
    tabPanel("slider",
             sliderInput("slider", "n", value = 0, min = 0, max = 100)
             ),
    tabPanel("numeric",
             numericInput("numeric", "n", value = 0, min = 0, max = 100) 
             )
  )
)

server <- function(input, output, session) {
  observeEvent(input$slider, {
    updateNumericInput(inputId = "numeric", value = isolate(input$slider)) 
  })
  
  observeEvent(input$numeric, {
    updateSliderInput(inputId = "slider", value = isolate(input$numeric)) 
  })
  
  observeEvent(input$type, {
    updateTabsetPanel(inputId = "switch", selected = input$type)
  })
}

shinyApp(ui, server)
