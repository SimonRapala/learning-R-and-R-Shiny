library(shiny)

ui <- fluidPage(
  titlePanel("Checkpoint 1 Settings"),
  sidebarLayout(
    sidebarPanel = sidebarPanel(
      h5("Enter Name"),
      textInput(
        inputId = "userName",
        "User Name: "
      ),
      h5("Choose Marker"),
      selectInput(
        inputId = "marker",
        label = "Genetic Markers",
        choices = c("COI", "16S", "ITS")
      ),
      h5("Memory Allocation"),
      numericInput(
        inputId = "memoryGB",
        label = "Memory(GB)",
        value = 8,
        min = 4,
        max = 128,
        step = 2
      ),
      h5("Pseudogene Filter"),
      checkboxInput(
        inputId = "filter",
        label = "Use pseudogene filtering",
        value = FALSE
      ),
      actionButton(
        inputId = "saveButton",
        label = "Save"
      ),
      actionButton(
        inputId = "runMetaWorks",
        label = "Run MetaWorks"
      )
    ),
    mainPanel(
      tabsetPanel(
        tabPanel(
          title = "Notifications",
          h3("Notifications"),
          verbatimTextOutput("notifications"),
          verbatimTextOutput("status")
        ),
        tabPanel(
          title = "Preview Run",
          h3("Submitted Configuration"),
          verbatimTextOutput("savedConfig")
        )
      )
    )
  )
)


server <- function(input, output, session) {
  status <- reactiveVal("Not Started")
  currentConfig <- reactiveVal(NULL)

  observeEvent(input$saveButton, {
    currentConfig(
      list(
        userName = input$userName,
        marker = input$marker,
        memory = input$memoryGB,
        filter = input$filter
      )
    )

    status("Configuration Saved")
  })

  observeEvent(input$runMetaWorks, {
    currentConfig(
      list(
        userName = input$userName,
        marker = input$marker,
        memory = input$memoryGB,
        filter = input$filter
      )
    )

    status("Configuration Submitted")
  })

  output$status <- renderText({
    status()
  })

  output$notifications <- renderText({
    config <- currentConfig()

    req(config)

    validate(
      need(
        trimws(config$userName) != "",
        "Please enter a user name."
      ),
      need(
        config$memory >= 8,
        "Please increase memory allocation to at least 8 GB."
      )
    )

    "Configuration is valid."
  })

  output$savedConfig <- renderPrint({
    config <- currentConfig()

    req(config)

    validate(
      need(
        trimws(config$userName) != "",
        "Please enter a user name."
      ),
      need(
        config$memory >= 8,
        "Please increase memory allocation to at least 8 GB."
      )
    )

    config
  })
}

shinyApp(
  ui = ui,
  server = server
)