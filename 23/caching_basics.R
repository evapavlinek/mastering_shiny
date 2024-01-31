library(shiny)
library(purrr)

latest_events <- function(username) {
  json <- gh::gh("/users/{username}/events/public", username = username)
  tibble::tibble(
    repo = json %>% map_chr(c("repo", "name")),
    type = json %>% map_chr("type"),
  )
}

system.time(hadley <- latest_events("hadley"))
head(hadley)


# an app
ui <- fluidPage(
  textInput("username", "GitHub user name"),
  tableOutput("events")
)

server <- function(input, output, session) {
  events <- reactive({
    req(input$username)
    latest_events(input$username)
  }) %>% bindCache(input$username, Sys.Date())
  output$events <- renderTable(events())
}

shinyApp(ui, server)

