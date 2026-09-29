library(shiny)


# User interface ----------------------------------------------------------

ui <- fluidPage(
  titlePanel("MetaWorks Run Interface"),

  sidebarLayout(
    sidebarPanel(
      textInput(
        inputId = "userName",
        label = "User name:"
      ),

      selectInput(
        inputId = "marker",
        label = "Genetic marker:",
        choices = c("COI", "16S", "ITS"),
        selected = "COI"
      ),

      numericInput(
        inputId = "memoryGB",
        label = "Memory (GB):",
        value = 10,
        min = 4,
        max = 64,
        step = 2
      ),

      checkboxInput(
        inputId = "pseudogeneFilter",
        label = "Use pseudogene filtering",
        value = TRUE
      ),

      actionButton(
        inputId = "runPipeline",
        label = "Run MetaWorks"
      )
    ),

    mainPanel(
      h3("Welcome"),
      textOutput("greeting"),

      hr(),

      h3("Run Status"),
      textOutput("runStatus"),

      hr(),

      h3("Submitted Settings"),
      verbatimTextOutput("submittedSettings"),
    )
  )
)


# Server logic ------------------------------------------------------------

server <- function(input, output, session) {

  # Updates automatically when the name changes
  output$greeting <- renderText({
    if (input$userName == "") {
      return("Enter your name to begin.")
    }

    paste0(
      "Welcome, ",
      input$userName,
      ". Welcome to MetaWorks!"
    )
  })


  # Stores one changing value
  runStatus <- reactiveVal("Not started")


  # Captures settings only when the button is clicked
  submittedSettings <- eventReactive(
    input$runPipeline,
    {
      req(
        input$userName != "",
        input$memoryGB >= 4
        )
      list(
        userName = input$userName,
        marker = input$marker,
        memoryGB = input$memoryGB,
        pseudogeneFilter = input$pseudogeneFilter
      )
    }
  )


  # Performs an action when the button is clicked
  observeEvent(input$runPipeline, {
    req(input$userName != "")
    runStatus("Run requested")
  })


  # Displays the stored status
  output$runStatus <- renderText({
    runStatus()
  })


  # Displays the settings captured by eventReactive()
  output$submittedSettings <- renderPrint({
    submittedSettings()
  })
}


# Run application ---------------------------------------------------------

shinyApp(
  ui = ui,
  server = server
)