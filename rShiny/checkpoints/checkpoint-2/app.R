#imports the shiny library
library(shiny)
#changes the setting to limit the max size of upload to 500 MiB
options(
  shiny.maxRequestSize = 500 * 1024^2
)

#function that verifies file pairings
filePairingVerification <- function(fastQFiles) {
  #separates the fwd and rev reads, as bools
  fwdReadBool <- grepl("_R1_", fastQFiles)
  revReadBool <- grepl("_R2_", fastQFiles)
  #actually separates the files into 2 vectors
  fwdRead <- fastQFiles[fwdReadBool]
  revRead <- fastQFiles[revReadBool]
  #gets the expected reverse reads based of fwd reads
  expectedRevRead <- sub(
    "_R1_",
    "_R2_",
    fwdRead
  )
  #gets the expected fwd reads based off present rev reads
  expectedFwdRead <- sub(
    "_R2_",
    "_R1_",
    revRead
  )
  #if the expected reads are present in relevent vector
  hasRevPair <- expectedRevRead %in% revRead
  hasFwdPair <- expectedFwdRead %in% fwdRead
  #pairs up the present read pairs
  pairs <- data.frame(
    fwdRead = fwdRead[hasRevPair],
    revRead = expectedRevRead[hasRevPair]
  )
  #identifies the missing fwd and rev reads
  missingR1 <- expectedFwdRead[!hasFwdPair]
  missingR2 <- expectedRevRead[!hasRevPair]
  #returns list with pair reads along with missing reads
  return(
    list(
      pairs = pairs,
      missingR1 = missingR1,
      missingR2 = missingR2
    )
  )
}

#creates the job directory that will store unique MetaWorks runs
createJobsDir <- function(workingDir) {
  #creates a directory in the wd() then folders project/jobs/
  rootPath <- file.path(
    workingDir,
    "project",
    "jobs"
  )
  #if the do not exist actually makes them and all dependent folders
  if (!dir.exists(rootPath)) {
    creationStatus <- dir.create(rootPath, recursive = TRUE)
    if (!creationStatus) {
      stop("Directory Creation Failed")
    }
  }
  #creates folder with todays date and time of metaworks run
  date <- format(Sys.time(), format = "MW-%Y-%m-%d_%H-%M-%S")

  dirName <- file.path(
    rootPath,
    date
  )
  #ensures it DNE yet
  if (dir.exists(dirName)) {
    stop("Directory Already Exists")
  }
  #creates it if it doesnt exist
  dirStatus <- dir.create(dirName, recursive = TRUE)
  #if creation fails
  if (!dirStatus) {
    stop("Directory Creation Failed")
  }
  #returns the directory path for usage
  return(dirName)
}

#fucntion that copies files from temp shiny to permenant folder
copyIntoPermanent <- function(fastQUpload, adapterUpload, jobDirectory) {
  #ensures it exists
  if (!dir.exists(jobDirectory)) {
    stop("Directory Does Not Exist")
  }
  #creates the path for input files
  inputPath <- file.path(
    jobDirectory,
    "inputs"
  )
  #creates the actual imput directory
  if (!dir.exists(inputPath)) {
    inputPathStatus <- dir.create(inputPath)
    if (!inputPathStatus) {
      stop("Input Path Failed Creation")
    }
  }
  #combines the files ontop of one another
  combinedFiles <- rbind(
    fastQUpload,
    adapterUpload
  )
  #gets the values of of each row for the name and datapath columns
  combinedDatapath <- combinedFiles[["datapath"]]
  combinedName <- combinedFiles[["name"]]
  #creates a new file path for each file
  filePaths <- file.path(
    inputPath,
    combinedName
  )
  #copies the files from the datapath to the new filepaths
  copyResults <- file.copy(
    combinedDatapath,
    filePaths,
    overwrite = FALSE
  )
  #they all need to succeed
  if (!all(copyResults)) {
    stop("One or more files could not be copied")
  }
  #returns the paths
  return(filePaths)
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
          ),
          downloadButton(
            outputId = "jobSummary",
            label = "Download Job Summary"
          )
        )
      )
    )
  )
)


server <- function(input, output, session) {
  jobSummary <- reactiveVal(NULL)
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
      req(input$fastQFiles)
      req(input$adapterFile)
      jobSummary(NULL)

      statusText <- tryCatch(
        expr = {
          withProgress(
            message = "Job Started",
            value = 0,
            expr = {
              incProgress(
                amount = 0.25,
                detail = "Root Creation Has Started"
              )
              rootPath <- createJobsDir(
                getwd()
              )
              incProgress(
                amount = 0.25,
                detail = "Root Path Has Been Created"
              )
              copiedToPaths <- copyIntoPermanent(
                input$fastQFiles,
                input$adapterFile,
                rootPath
              )

              incProgress(
                amount = 0.5,
                detail = "Copied Files Into Persistant Folder"
              )

              pathwayPrint <- paste0(
                "Job Path: ",
                rootPath
              )

              for (path in seq_along(copiedToPaths)) {
                pathwayPrint <- paste0(
                  pathwayPrint,
                  "\nPath[",
                  path,
                  "]: ",
                  copiedToPaths[path]
                )
              }
              showNotification(
                ui = "Uploaded File Saved Successfully",
                duration = 5,
                type = "message"
              )
              jobSummary(list(
                jobPath = rootPath,
                copiedFiles = copiedToPaths,
                createdAt = format(Sys.time(), format = "%Y-%m-%d_%H-%M-%S")
              ))
              pathwayPrint
            }
          )
        },
        error = function(error) {
          errorText <- paste0(
            "Error: ",
            conditionMessage(error)
          )

          showNotification(
            ui = errorText,
            type = "error",
            duration = 8
          )

          return(errorText)
        }
      )

      output$statusProgress <- renderText({
        statusText
      })
    }
  )

  output$jobSummary <- downloadHandler(
    filename = function() {
      req(jobSummary())

      paste0(
        "MetaWorks-Job-Summary-",
        jobSummary()$createdAt,
        ".txt"
      )
    },
    content = function(file){
      req(jobSummary())

      summaryLines <- c(
        "MetaWorks Job Summary",
        paste0("Created: ", jobSummary()$createdAt),
        paste0("Copied To: ", jobSummary()$copiedFiles, collapse = "\n"),
        paste0("Job Directory: ", jobSummary()$jobPath)
      )

      writeLines(
        summaryLines,
        file
      )
    }
  )
}


shinyApp(
  ui = ui,
  server = server
)
