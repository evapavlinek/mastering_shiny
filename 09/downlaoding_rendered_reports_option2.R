# By default, RMarkdown will render the report in the current process, which means that it will inherit many settings 
# from the Shiny app (like loaded packages, options, etc). For greater robustness, I recommend running render() in a 
# separate R session using the callr package:

library(shiny)

ui <- fluidPage(
  sliderInput("n", "Number of points", 1, 100, 50),
  downloadButton("report", "Generate report")
)

render_report <- function(input, output, params) {
  rmarkdown::render(input,
                    output_file = output,
                    params = params,
                    envir = new.env(parent = globalenv())
  )
}

server <- function(input, output) {
  output$report <- downloadHandler(
    filename = "report.html",
    content = function(file) {
      params <- list(n = input$slider)
      callr::r(
        render_report,
        list(input = report_path, output = file, params = params)
      )
    }
  )
}

shinyApp(ui, server)