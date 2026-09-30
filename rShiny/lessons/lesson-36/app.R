library(shiny)

options(
  shiny.maxRequestSize = 500 * 1024^2
)


copyUploadedFiles <- function(uploadInfo, inputDirectory) {
  if (!dir.exists(inputDirectory)) {
    dir.create(
      inputDirectory,
      recursive = TRUE
    )
  }

  originalNames <- basename(uploadInfo$name)

  if (anyDuplicated(originalNames)) {
    stop("Duplicate filenames were uploaded.")
  }

  destinationPaths <- file.path(
    inputDirectory,
    originalNames
  )

  copyResults <- file.copy(
    from = uploadInfo$datapath,
    to = destinationPaths,
    overwrite = FALSE
  )

  if (!all(copyResults)) {
    stop("One or more files could not be copied.")
  }

  return(destinationPaths)
}


ui <- fluidPage(
  titlePanel("MetaWorks Upload Manager"),
  fileInput(
    inputId = "fastqFiles",
    label = "Upload FASTQ files",
    multiple = TRUE,
    accept = ".fastq.gz"
  ),
  actionButton(
    inputId = "saveUploads",
    label = "Save uploaded files"
  ),
  verbatimTextOutput(
    outputId = "saveStatus"
  ),
  h3("Uploaded File Information"),
  tableOutput(
    outputId = "fastqInformation"
  )
)
server <- function(input, output, session) {
  output$fastqInformation <- renderTable({
    req(input$fastqFiles)
    maxFileSize <- 200 * 1024^2
    maxTotalSize <- 500 * 1024^2

    validate(
      need(
        all(input$fastqFiles$size <= maxFileSize),
        "Each FASTQ file must be 200 MB or smaller."
      ),
      need(
        sum(input$fastqFiles$size) <= maxTotalSize,
        "The combined upload must be 500 MB or smaller."
      )
    )

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
      "type",
      "datapath"
    )]
  })


  saveStatus <- eventReactive(
    input$saveUploads,
    {
      req(input$fastqFiles)

      inputDirectory <- file.path(
        getwd(),
        "jobs",
        "practice-run",
        "inputs"
      )

      copiedPaths <- copyUploadedFiles(
        uploadInfo = input$fastqFiles,
        inputDirectory = inputDirectory
      )

      paste(
        "Saved:",
        copiedPaths,
        collapse = "\n"
      )
    }
  )

  output$saveStatus <- renderText({
    saveStatus()
  })
}

shinyApp(
  ui = ui,
  server = server
)
