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

#allows the UI to be fluid, responsive based on the users browser
ui <- fluidPage(
  #controls the windows name and the title of the page
  titlePanel(
    title = "Rough MetaWorks",
    windowTitle = "MetaWorks"
  ),
  #2 panel layout, sidebar for settingsand main for ddisplay
  sidebarLayout(
    #elements contained in sidebar
    sidebarPanel = sidebarPanel(
      #input button that only allows upload of fastq.gz files
      fileInput(
        inputId = "fastQFiles",
        label = "Please Select FastQ Files",
        multiple = TRUE,
        accept = ".fastq.gz"
      ),
      #input button that only allows upload of a singular fasta file
      fileInput(
        inputId = "adapterFile",
        label = "Please Select Adapter File",
        multiple = FALSE,
        accept = ".fasta"
      ),
      #button that tracks when its has been clicked
      actionButton(
        inputId = "createJob",
        label = "Create Job"
      )
    ),
    #main panel that will display output info
    mainPanel = mainPanel(
      #panel design that groups related content under diffent tabs
      tabsetPanel(
        #one of the panels
        tabPanel(
          #panel info
          "File Info",
          #outputs a table with rows and columns
          tableOutput(
            outputId = "fileInfo"
          )
        ),
        #another panel
        tabPanel(
          title = "Pairing",
          #pre designed output box
          verbatimTextOutput(
            outputId = "filePairingInfo"
          )
        ),
        #another panel
        tabPanel(
          title = "Information",
          verbatimTextOutput(
            outputId = "statusProgress"
          ),
          #a button that allows user to download files
          downloadButton(
            outputId = "jobSummary",
            label = "Download Job Summary"
          )
        )
      )
    )
  )
)

#actually tracks actions and determines what should happen
server <- function(input, output, session) {
  #a value that can be over written to store a summary of the files
  jobSummary <- reactiveVal(NULL)
  #global in the server for max sizes to enfore maximums
  maxFileSize <- 100 * 1024^2
  maxTotalSize <- 500 * 1024^2

  #prints the table to related output
  output$fileInfo <- renderTable({
    #every need in validate needs to pass else it will display the message
    validate(
      #what needs to be true and the message if not true
      need(
        !is.null(input$fastQFiles),
        "Please upload FASTQ files."
      ),
      need(
        !is.null(input$adapterFile),
        "Please upload adapters.fasta."
      )
    )
    #combines all the files names together into one vector
    allNames <- c(
      input$fastQFiles$name,
      input$adapterFile$name
    )
    #combines all file sizes into one vector
    allSizes <- c(
      input$fastQFiles$size,
      input$adapterFile$size
    )
    #ensures all provided fastq files are correct name format
    validFastQNames <- grepl(
      "\\.fastq\\.gz$",
      input$fastQFiles$name,
      ignore.case = TRUE
    )
    #enforces a strict fasta name
    validAdapterName <- (
      tolower(input$adapterFile$name) ==
        "adapters.fasta"
    )
    #ensures all these are true to continue
    validate(
      #all fastq names are valid
      need(
        all(validFastQNames),
        "Every FASTQ file must end in .fastq.gz."
      ),
      #fasta name has to be adapters.fasta
      need(
        validAdapterName,
        "The adapter file must be named adapters.fasta."
      ),
      #checks if any of the names are duplicates
      need(
        anyDuplicated(allNames) == 0,
        "Duplicate filenames are not allowed."
      ),
      #all file sizes are smaller then enforced amoutn per file
      need(
        all(allSizes <= maxFileSize),
        "Each file must be 100 MiB or smaller."
      ),
      #ensures combined total size is less then enforced value
      need(
        sum(allSizes) <= maxTotalSize,
        "The combined upload must be 500 MiB or smaller."
      )
    )
    #isolates these attributes into a new vector for fastq
    fastQInfo <- input$fastQFiles[, c(
      "name",
      "size",
      "type"
    )]
    #isolates these attributes into a new vector for fasta
    adapterInfo <- input$adapterFile[, c(
      "name",
      "size",
      "type"
    )]
    #stacks these two vectors together to mkae a table format
    rbind(
      fastQInfo,
      adapterInfo
    )
  })
  #will print out the returned info to related output
  output$filePairingInfo <- renderPrint({
    #ensures that fastq fiels have been uploaded
    req(input$fastQFiles)
    #calls helper that will verify pairings
    pairs <- filePairingVerification(
      fastQFiles = input$fastQFiles$name
    )
    #displays nicely the output
    cat("Pairs:\n")
    print(pairs$pairs)

    cat("\nMissing R1 files:\n")
    print(pairs$missingR1)

    cat("\nMissing R2 files:\n")
    print(pairs$missingR2)
  })

  #observes for a change in the create job button
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
