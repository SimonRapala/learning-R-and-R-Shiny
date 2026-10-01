library(shiny)
options(
  shiny.maxRequestSize = 500 * 1024^2
)

filePairingVerification <- function(fastQFiles) {
  fwdReadBool <- grepl("_R1_", fastQFiles)
  revReadBool <- grepl("_R2_", fastQFiles)

  fwdRead <- fastQFiles[fwdReadBool]
  revRead <- fastQFiles[revReadBool]

  expectedRevRead <- sub(
    "_R1_",
    "_R2_",
    fwdRead
  )

  expectedFwdRead <- sub(
    "_R2_",
    "_R1_",
    revRead
  )

  hasRevPair <- expectedRevRead %in% revRead
  hasFwdPair <- expectedFwdRead %in% fwdRead

  pairs <- data.frame(
    fwdRead = fwdRead[hasRevPair],
    revRead = expectedRevRead[hasRevPair]
  )

  missingR1 <- expectedFwdRead[!hasFwdPair]
  missingR2 <- expectedRevRead[!hasRevPair]

  return(
    list(
      pairs = pairs,
      missingR1 = missingR1,
      missingR2 = missingR2
    )
  )
}


createJobsDir <- function(workingDir) {
  rootPath <- file.path(
    workingDir,
    "project",
    "jobs"
  )
  if (!dir.exists(rootPath)) {
    creationStatus <- dir.create(rootPath, recursive = TRUE)
    if (!creationStatus) {
      stop("Directory Creation Failed")
    }
  }

  date <- format(Sys.time(), format = "MW-%Y-%m-%d_%H-%M-%S")

  dirName <- file.path(
    rootPath,
    date
  )

  if (dir.exists(dirName)) {
    stop("File Already Exists")
  }

  dirStatus <- dir.create(dirName, recursive = TRUE)

  if (!dirStatus) {
    stop("File Creation Failed")
  }

  return(dirName)
}


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
      ),
      actionButton(
        inputId = "createJob",
        label = "Create Job"
      )
    ),
    mainPanel = mainPanel(
      tabsetPanel(
        tabPanel(
          "File Info",
          tableOutput(
            outputId = "fileInfo"
          )
        ),
        tabPanel(
          title = "Pairing",
          verbatimTextOutput(
            outputId = "filePairingInfo"
          )
        ),
        tabPanel(
          title = "Information",
          verbatimTextOutput(
            outputId = "statusProgress"
          )
        )
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

  output$filePairingInfo <- renderPrint({
    req(input$fastQFiles)

    pairs <- filePairingVerification(
      fastQFiles = input$fastQFiles$name
    )

    cat("Pairs:\n")
    print(pairs$pairs)

    cat("\nMissing R1 files:\n")
    print(pairs$missingR1)

    cat("\nMissing R2 files:\n")
    print(pairs$missingR2)
  })


  observeEvent(
    eventExpr = input$createJob,
    handlerExpr = {
      output$statusProgress <- renderText(
        tryCatch(
          expr = {
            rootPath <- createJobsDir(getwd())
            pathwayPrint <- paste0("Path: ", rootPath)
            return(pathwayPrint)
          },
          error = function(error) {
            return(paste0("Error: ", conditionMessage(error)))
          }
        )
      )
    }
  )
}


shinyApp(
  ui = ui,
  server = server
)
