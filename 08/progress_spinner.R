library(shiny)
library(waiter)

ui <- fluidPage(
  waiter::use_waiter(),
  actionButton("go", "go"),
  textOutput("result")
)

server <- function(input, output, session) {
  data <- eventReactive(input$go, {
    waiter <- waiter::Waiter$new()
    # more styles with ?waiter::spinners
    #waiter <- waiter::Waiter$new(html = spin_ripple())
    #waiter <- waiter::Waiter$new(html = spin_rotating_plane())
    waiter$show()
    on.exit(waiter$hide())
    
    Sys.sleep(sample(5, 1))
    runif(1)
  })
  output$result <- renderText(round(data(), 2))
}

shinyApp(ui, server)