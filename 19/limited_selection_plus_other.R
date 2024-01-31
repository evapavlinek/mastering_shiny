library(shiny)

radioExtraUI <- function(id, label, choices, selected = NULL, placeholder = "Other") {
  other <- textInput(NS(id, "other"), label = NULL, placeholder = placeholder)
  
  names <- if (is.null(names(choices))) choices else names(choices)
  values <- unname(choices)
  
  radioButtons(NS(id, "primary"), 
               label = label,
               choiceValues = c(names, "other"),
               choiceNames = c(as.list(values), list(other)),
               selected = selected
  )
}

genderUI <- function(id, label = "Gender") {
  radioExtraUI(id, 
               label = label,
               choices = c(
                 male = "Male",
                 female = "Female",
                 na = "Prefer not to say"
               ), 
               placeholder = "Self-described", 
               selected = "na"
  )
}


radioExtraServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    observeEvent(input$other, ignoreInit = TRUE, {
      updateRadioButtons(session, "primary", selected = "other")
    })
    
    reactive({
      if (input$primary == "other") {
        input$other
      } else {
        input$primary
      }
    })
  })
}


radioExtraApp <- function(...) {
  ui <- fluidPage(
    radioExtraUI("extra", label = "This is the label description", choices = letters[1:3]),
    textOutput("value"),
    genderUI("someID")
    # any additional selections
    # radioExtraUI("extra2", label = "This is the label description", choices = letters[4:8]),
    # textOutput("value2")
  )
  server <- function(input, output, server) {
    extra <- radioExtraServer("extra")
    output$value <- renderText(paste0("Selected: ", extra()))
    # any additional selections
    # extra2 <- radioExtraServer("extra2")
    # output$value2 <- renderText(paste0("Selected: ", extra2()))
  }
  
  shinyApp(ui, server)
}

radioExtraApp()
