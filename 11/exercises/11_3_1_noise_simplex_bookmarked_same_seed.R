# 11.3.1 Generate app for visualising the results of ambient::noise_simplex(). Your app should allow 
# the user to control the frequency, fractal, lacunarity, and gain, and be bookmarkable. How can you 
# ensure the image looks exactly the same when reloaded from the bookmark? (Think about what the seed 
# argument implies).

library(shiny)
library(ambient)

ui <- function(request) {
  fluidPage(
    sidebarLayout(
      sidebarPanel(
        sliderInput("frequency", "Frequency", min = 0.01, max = 1, value = 0.05),
        sliderInput("lacunarity", "Lacunarity", min = -10, max = 10, value = 2),
        sliderInput("gain", "Gain", min = -10, max = 10, value = 0.5),
        selectInput("fractal", "Fractal", choices = c("fbm", "none", "billow", "rigid-multi")),
        bookmarkButton()
      ),
      mainPanel(
        plotOutput("plot")
      )
    )
  )
}

server <- function(input, output, session) {
  freq <- reactive(input$frequency)
  lacunarity <- reactive(input$lacunarity)
  gain <- reactive(input$gain)
  fractal <- reactive(input$fractal)
  
  noise.generator <- repeatable(noise_simplex)
  
  noise <- reactive({
    noise.generator(
      c(2000, 2000),
      frequency = freq(),
      fractal = fractal(),
      lacunarity = lacunarity(),
      gain = gain()
    )
  })
  
  output$plot <- renderPlot({
    plot(as.raster(normalise(noise())))
    })
}

shinyApp(ui, server, enableBookmarking = "url")


