
ui <- fluidRow(
  sliderInput("alpha", "alpha", min = 0, max = 1, value = 0.5, step = 0.1),
  sliderInput("beta",  "beta",  min = 0, max = 1, value = 0.5, step = 0.1),
  sliderInput("gamma", "gamma", min = 0, max = 1, value = 0.5, step = 0.1),
  sliderInput("delta", "delta", min = 0, max = 1, value = 0.5, step = 0.1)
)

# instead:
sliderInput01 <- function(id) {
  sliderInput(id, label = id, min = 0, max = 1, value = 0.5, step = 0.1)
}

ui <- fluidRow(
  sliderInput01("alpha"),
  sliderInput01("beta"),
  sliderInput01("gamma"),
  sliderInput01("delta")
)

# functional programming
library(purrr)

vars <- c("alpha", "beta", "gamma", "delta")
sliders <- map(vars, sliderInput01)
ui <- fluidRow(sliders)

# for more parameters
vars <- tibble::tribble(
  ~ id,   ~ min, ~ max,
  "alpha",     0,     1,
  "beta",      0,    10,
  "gamma",    -1,     1,
  "delta",     0,     1,
)

mySliderInput <- function(id, label = id, min = 0, max = 1) {
  sliderInput(id, label, min = min, max = max, value = 0.5, step = 0.1)
}

sliders <- pmap(vars, mySliderInput)




# some other options: 

# a date control for Americans to use to select weekdays
usWeekDateInput <- function(inputId, ...) {
  dateInput(inputId, ..., format = "dd M, yy", daysofweekdisabled = c(0, 6))
}


# a radio button that makes it easier to provide icons
iconRadioButtons <- function(inputId, label, choices, selected = NULL) {
  names <- lapply(choices, icon)
  values <- if (is.null(names(choices))) names(choices) else choices
  radioButtons(inputId,
               label = label,
               choiceNames = names, choiceValues = values, selected = selected
  )
}





