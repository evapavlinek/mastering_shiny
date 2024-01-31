# Create a slider input to select values between 0 and 100 where the interval between each 
# selectable value on the slider is 5. Then, add animation to the input widget so when the user 
# presses play the input widget scrolls through the range automatically.

library(shiny)

ui <- fluidPage(
  sliderInput("value", "Select the value", min = 0, max = 100, value = 50, step = 5, animate = TRUE)
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)