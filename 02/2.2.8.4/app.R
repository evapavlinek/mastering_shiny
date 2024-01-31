# If you have a moderately long list in a selectInput(), it’s useful to create sub-headings that 
# break the list up into pieces. Read the documentation to figure out how. 
# (Hint: the underlying HTML is called <optgroup>.)

library(shiny)

# ui <- fluidPage(
#   selectInput("state", "Choose a state:",
#               list(`East Coast` = list("NY", "NJ", "CT"),
#                    `West Coast` = list("WA", "OR", "CA"),
#                    `Midwest` = list("MN", "WI", "IA"))
#   ),
#   textOutput("result")
# )
# 
# server <- function(input, output) {
#   output$result <- renderText({
#     paste("You chose", input$state)
#   })
# }


ui <- fluidPage(
  selectInput("value", "Select the value:", choices = 
                list("small" = as.list(1:20),
                     "middle" = as.list(21:80),
                     "big" = as.list(81:100))
  )
)

server <- function(input, output, session) {

}

shinyApp(ui, server)