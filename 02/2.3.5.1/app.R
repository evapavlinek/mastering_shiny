# Which of textOutput() and verbatimTextOutput() should each of the following render functions 
# be paired with?
# renderPrint(summary(mtcars))
# renderText("Good morning!")
# renderPrint(t.test(1:5, 2:6))
# renderText(str(lm(mpg ~ wt, data = mtcars)))

library(shiny)

ui <- fluidPage(
  verbatimTextOutput("one"),
  textOutput("two"),
  verbatimTextOutput("three"),
  textOutput("four")
)

server <- function(input, output, session) {
  output$one <- renderPrint(summary(mtcars))
  output$two <- renderText("Good morning!")
  output$three <- renderPrint(t.test(1:5, 2:6))
  output$four <- renderText(str(lm(mpg ~ wt, data = mtcars)))
}

shinyApp(ui, server)