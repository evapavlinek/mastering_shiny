# Write an app that allows the user to create a Lego mosaic from any .png file using Ryan Timpe’s brickr package. 
# Once you’ve completed the basics, add controls to allow the user to select the size of the mosaic (in bricks), and 
# choose whether to use “universal” or “generic” colour palettes.

library(shiny)
library(brickr)
library(waiter)
library(ggplot2)

ui <- fluidPage(
  titlePanel("Let's turn your image into Lego bricks!"),
  sidebarLayout(
    sidebarPanel(
      fileInput("upload", "Upload the image in .png format", accept = ".png"),
      sliderInput("size", "Select the number of bricks", min = 10, max = 200, value = 50),
      selectInput("palette", "Select the colour palette", 
                  choices = c("default", "universal", "generic", "universal/generic", "special", "b/w"))
    ),
    mainPanel(
      use_waiter(),
      plotOutput("lego")
    )
  )
)

server <- function(input, output, session) {
  img <- reactive({
    req(input$upload)
    png::readPNG(input$upload$datapath)
  })
  
  size <- reactive(input$size)
  palette <- reactive({
    switch(input$palette,
           "default" = NULL,
           "universal" = "universal",
           "generic" = "generic", 
           "universal/generic" = "universal/generic", 
           "special" = "special", 
           "b/w" = "bw"
           )
    })
  
  lego_mosaic <- reactive({
    Waiter$new(id = "lego", html = spin_folding_cube())$show()
    
    id <- showNotification("Converting the image...", duration = NULL, closeButton = FALSE, type = "message")
    on.exit(removeNotification(id), add = TRUE)
    
    if (input$palette == "default") {
      img() %>%
        image_to_mosaic(img_size = size()) %>%
        build_mosaic()
    } else {
      img() %>%
        image_to_mosaic(img_size = size(), color_palette = palette()) %>%
        build_mosaic()
    }
  })
  
  output$lego <- renderPlot(lego_mosaic()) 
}

shinyApp(ui, server)




