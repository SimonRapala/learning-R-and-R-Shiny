library(shiny)


validateRunSettings <- function(
  userName,
  projectName,
  minimumOverlap,
  memoryGB
) {
  # Check that userName is not empty
  if (trimws(userName) == "") {
    stop("Username is empty!")
  }


  # Check that projectName is not empty
  if (trimws(projectName) == "") {
    stop("Project name is empty!")
  }


  # Check that minimumOverlap is at least 20
  if (minimumOverlap <= 20) {
    stop("Minimum Overlap is to low!")
  }


  # Check that memoryGB is at least 8
  if (memoryGB <= 8) {
    stop("Allocated memory is too low!")
  }


  # Return the validated settings as a list
  return(list(
    userName = userName,
    projectName = projectName,
    minimumOverlap = minimumOverlap,
    memoryGB = memoryGB
  ))
}


ui <- fluidPage(
  titlePanel("MetaWorks Run Validation"),
  textInput(
    inputId = "userName",
    label = "User name:"
  ),
  textInput(
    inputId = "projectName",
    label = "Project name:"
  ),
  numericInput(
    inputId = "minimumOverlap",
    label = "Minimum overlap:",
    value = 25,
    min = 1
  ),
  numericInput(
    inputId = "memoryGB",
    label = "Memory allocation (GB):",
    value = 10,
    min = 1
  ),
  actionButton(
    inputId = "validateRun",
    label = "Validate Settings"
  ),
  verbatimTextOutput(
    outputId = "validationResult"
  )
)


server <- function(input, output, session) {
  validationStatus <- reactiveVal(
    "Settings have not been validated."
  )

  observeEvent(
    eventExpr = input$validateRun,
    handlerExpr = {
      resultText <- tryCatch(
        expr = {
          validatedSettings <- validateRunSettings(
            userName = input$userName,
            projectName = input$projectName,
            minimumOverlap = input$minimumOverlap,
            memoryGB = input$memoryGB
          )

          paste(
            "Settings are valid:",
            paste(
              names(validatedSettings),
              validatedSettings,
              sep = " = ",
              collapse = "\n"
            ),
            sep = "\n"
          )
        },
        error = function(error) {
          paste(
            "Validation failed:",
            conditionMessage(error)
          )
        }
      )

      validationStatus(resultText)
    }
  )

  output$validationResult <- renderText({
    validationStatus()
  })
}


shinyApp(
  ui = ui,
  server = server
)
