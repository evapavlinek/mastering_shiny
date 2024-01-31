x <- reactive({
  invalidateLater(500)
  rnorm(10)
})

sum <- reactiveVal(0)
observe({
  invalidateLater(300)
  sum(isolate(sum()) + runif(1))
})



# polling
data <- reactive({
  on.exit(invalidateLater(1000))
  read.csv("data.csv")
})

server <- function(input, output, session) {
  data <- reactivePoll(1000, session, 
                       function() file.mtime("data.csv"),
                       function() read.csv("data.csv")
  )
}

server <- function(input, output, session) {
  data <- reactiveFileReader(1000, session, "data.csv", read.csv)
}