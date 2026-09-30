library(shiny)

ui <- fluidPage(
  titlePanel("MetaWorks Upload Manager"),
  fileInput(
    inputId = "fastqFiles",
    label = "Upload Fastq File",
    multiple = TRUE,
    accept = ".fastq.gz"
  ),
  h3("Uploaded File Information"),
  tableOutput(
  outputId = "fastqInformation"
)
)

server <- function(input, output, session) {
  output$fastqInformation <- renderTable({
  req(input$fastqFiles)

  validExtensions <- grepl(
    pattern = "\\.fastq\\.gz$",
    x = input$fastqFiles$name,
    ignore.case = TRUE
  )

  validate(
    need(
      all(validExtensions),
      "Every uploaded file must end in .fastq.gz"
    )
  )

  input$fastqFiles[, c(
    "name",
    "size",
    "type"
  )]
})
}

shinyApp(
  ui = ui,
  server = server
)
