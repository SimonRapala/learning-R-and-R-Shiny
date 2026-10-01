library(shiny)
options(
  shiny.maxRequestSize = 500 * 1024^2
)


ui <- fluidPage(
  titlePanel(
    title = "Rough MetaWorks",
    windowTitle = "MetaWorks"
  ),
  sidebarLayout(
    sidebarPanel = sidebarPanel(
      fileInput(
        inputId = "fastQFiles",
        label = "Please Select FastQ Files",
        multiple = TRUE,
        accept = ".fastq.gz"
      ),
      fileInput(
        inputId = "adapterFile",
        label = "Please Select Adapter File",
        multiple = FALSE,
        accept = ".fasta"
      )
    ),
    mainPanel = mainPanel(
      h3("File Info"),
      tableOutput(
        outputId = "fileInfo"
      )
    )
  )
)


server <- function(input, output, session) {
  maxFileSize <- 100 * 1024^2
  maxTotalSize <- 500 * 1024^2

  output$fileInfo <- renderTable({
    validate(
      need(
        !is.null(input$fastQFiles),
        "Please upload FASTQ files."
      ),
      need(
        !is.null(input$adapterFile),
        "Please upload adapters.fasta."
      )
    )

    allNames <- c(
      input$fastQFiles$name,
      input$adapterFile$name
    )

    allSizes <- c(
      input$fastQFiles$size,
      input$adapterFile$size
    )

    validFastQNames <- grepl(
      "\\.fastq\\.gz$",
      input$fastQFiles$name,
      ignore.case = TRUE
    )

    validAdapterName <- (
      tolower(input$adapterFile$name) ==
        "adapters.fasta"
    )

    validate(
      need(
        all(validFastQNames),
        "Every FASTQ file must end in .fastq.gz."
      ),
      need(
        validAdapterName,
        "The adapter file must be named adapters.fasta."
      ),
      need(
        anyDuplicated(allNames) == 0,
        "Duplicate filenames are not allowed."
      ),
      need(
        all(allSizes <= maxFileSize),
        "Each file must be 100 MiB or smaller."
      ),
      need(
        sum(allSizes) <= maxTotalSize,
        "The combined upload must be 500 MiB or smaller."
      )
    )

    fastQInfo <- input$fastQFiles[, c(
      "name",
      "size",
      "type"
    )]

    adapterInfo <- input$adapterFile[, c(
      "name",
      "size",
      "type"
    )]

    rbind(
      fastQInfo,
      adapterInfo
    )
  })
}


shinyApp(
  ui = ui,
  server = server
)
