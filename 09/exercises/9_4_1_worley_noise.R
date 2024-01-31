# Use the ambient package by Thomas Lin Pedersen to generate worley noise and download a PNG of it.

library(shiny)
library(ambient)
library(dplyr)

ui <- fluidPage(
  titlePanel("Let's make some worley noise!"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("x", "x", 10, min = 1, max = 100),
      sliderInput("y", "y", 10, min = 1, max = 100),
      sliderInput("h", "heigth", 500, min = 10, max = 1000),
      sliderInput("w", "width", 500, min = 10, max = 1000),
      sliderInput("d", "divider", 2, min = -10, max = 10),
      downloadButton("download", "Download the image", class = "btn-primary")
      ),
    mainPanel(
      plotOutput("plot")
      )
  )
)


server <- function(input, output, session) {
  x <- reactive(input$x)
  y <- reactive(input$y)
  h <- reactive(input$h)
  w <- reactive(input$w)
  d <- reactive(input$d)
  
  worley_df <- reactive({
    df <- long_grid(x = seq(0, x(), length.out = w()),
              y = seq(0, y(), length.out = h())) %>%
      mutate(
        x1 = x + gen_simplex(x, y) / d(),
        y1 = y + gen_simplex(x, y) / d(),
        worley = gen_worley(x, y, value = 'distance', seed = 5),
        worley_frac = fracture(gen_worley, ridged, octaves = 8, x = x, y = y,
                               value = 'distance', seed = 5),
        full = blend(normalise(worley), normalise(worley_frac), gen_spheres(x1, y1))
        )
    pmat <- matrix(df$full, nrow = h(), ncol = w())
    })
  
  output$plot <- renderPlot(plot(as.raster(worley_df())))
  
  output$download <- downloadHandler(
    filename = "worley_noise.png",
    content = function(file) {
      png(file)
      plot(as.raster(worley_df()))
      dev.off()
    }
  )
}

shinyApp(ui, server)

