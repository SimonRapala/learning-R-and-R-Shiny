library(shiny)

ui <- fluidPage(
  titlePanel("MetaWorks Upload Manager"),
  fileInput(
    inputId = "adapterFile",
    label = "Upload adapter file",
    multiple = FALSE,
    accept = c(".fasta", ".fa")
  ),
  h3("Uploaded File Information"),
  verbatimTextOutput(
    outputId = "fileInformation"
  ),
  verbatimTextOutput(
    outputId = "inspectElements"
  )
)

server <- function(input, output, session) {
  output$fileInformation <- renderPrint({
    req(input$adapterFile)

    input$adapterFile
  })

  output$inspectElements <- renderPrint({
    req(input$adapterFile)

    result <- cat(
      "Name: ", input$adapterFile$name, "\nType: ", input$adapterFile$type,
      "\nSize: ", input$adapterFile$size, "\nPath: ", input$adapterFile$datapath
    )

    result
  })
}

shinyApp(
  ui = ui,
  server = server
)
