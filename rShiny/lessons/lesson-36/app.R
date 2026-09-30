library(shiny)
# forces a session rule, cannot take bigger files than this
options(
  shiny.maxRequestSize = 500 * 1024^2
)

# function that takes in input$fastQFiles and a job directory path
copyUploadedFiles <- function(uploadInfo, inputDirectory) {
  # if directory DNE then creates it
  if (!dir.exists(inputDirectory)) {
    dir.create(
      inputDirectory,
      recursive = TRUE
    )
  }
  # drops the path and leaves just file names
  originalNames <- basename(uploadInfo$name)
  # checks if any of the files are duplicated
  if (anyDuplicated(originalNames)) {
    stop("Duplicate filenames were uploaded.")
  }
  # creates a filepath for files in new directory
  destinationPaths <- file.path(
    inputDirectory,
    originalNames
  )
  # moves the files from tmp pathway to the permanent folder location
  copyResults <- file.copy(
    from = uploadInfo$datapath,
    to = destinationPaths,
    overwrite = FALSE
  )
  # checks if all files copied using truthy values returned
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
  ),
  downloadButton(
    outputId = "downloadManifest",
    label = "Download file manifest"
  )
)
server <- function(input, output, session) {
  output$fastqInformation <- renderTable({
    # reuires the files to exist
    req(input$fastqFiles)
    # max sizes in total and per file in MB(byte * KB * MB)
    maxFileSize <- 200 * 1024^2
    maxTotalSize <- 500 * 1024^2
    # ensures that none of the files exceed the size
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
    # returns a truthy table to ensure all files are valid
    validExtensions <- grepl(
      pattern = "\\.fastq\\.gz$",
      x = input$fastqFiles$name,
      ignore.case = TRUE
    )
    #
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

      runID <- format(
        Sys.time(),
        "%Y/%m/%d|%H-%M-%S"
      )

      inputDirectory <- file.path(
        getwd(),
        "jobs",
        runID,
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


  output$downloadManifest <- downloadHandler(
    filename = function() {
      paste0(
        "upload-manifest-",
        Sys.Date(),
        ".csv"
      )
    },
    content = function(file) {
      req(input$fastqFiles)

      manifest <- input$fastqFiles[, c(
        "name",
        "size",
        "type"
      )]

      write.csv(
        manifest,
        file,
        row.names = FALSE
      )
    }
  )
}

shinyApp(
  ui = ui,
  server = server
)
