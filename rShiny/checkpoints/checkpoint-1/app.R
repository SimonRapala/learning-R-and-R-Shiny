#tells the program to import shiny lib
library(shiny)
#the visual portion of the site
ui <- fluidPage(
  #breaks up the page into a sidepanel and main panel
  titlePanel("Checkpoint 1 Settings"),
  sidebarLayout(
    #holds all the settings that user can change
    sidebarPanel = sidebarPanel(
      h5("Enter Name"),
      #provides the user with a textbox to write name
      textInput(
        inputId = "userName",
        "User Name: "
      ),
      h5("Choose Marker"),
      #gives the user a selection of boxes to choose
      selectInput(
        inputId = "marker",
        label = "Genetic Markers",
        choices = c("COI", "16S", "ITS")
      ),
      h5("Memory Allocation"),
      #allows the user to type in memory or user arrows to change
      numericInput(
        inputId = "memoryGB",
        label = "Memory(GB)",
        value = 8,
        min = 4,
        max = 128,
        step = 2
      ),
      h5("Pseudogene Filter"),
      #a checkbox that enabled filtering
      checkboxInput(
        inputId = "filter",
        label = "Use pseudogene filtering",
        value = FALSE
      ),
      #a button that tracks clicks
      actionButton(
        inputId = "saveButton",
        label = "Save"
      ),
      #a button that tracks clicks
      actionButton(
        inputId = "runMetaWorks",
        label = "Run MetaWorks"
      )
    ),
    #displays the information if it passes checks
    mainPanel = mainPanel(
      tabsetPanel(
        #splits the other panel into clickable tabs
        tabPanel(
          title = "Notifications",
          h3("Notifications"),
          #outputs the warnings and the status to formatted boxes
          verbatimTextOutput("notifications"),
          verbatimTextOutput("status")
        ),
        #splits the other panel into clickable tabs
        tabPanel(
          title = "Preview Run",
          h3("Submitted Configuration"),
          #outputs the settings to a formatted box
          verbatimTextOutput("savedConfig")
        )
      )
    )
  )
)

#manages the information processing that is recieved and sent
server <- function(input, output, session) {
  #variables that act like boxes and hold data
  status <- reactiveVal("Not Started")
  currentConfig <- reactiveVal(NULL)
  #is run on button press, 2 codes because status update is different
  observeEvent(input$saveButton, {
    #updates the currentConfig box with the input list
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
  #is run on button press, 2 codes because status update is different
  observeEvent(input$runMetaWorks, {
    #updates the currentConfig box with the input list
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
  #prints out the status to the reserved spot
  output$status <- renderText({
    status()
  })
  #prints out notifications to the reserved spot
  output$notifications <- renderText({
    config <- currentConfig()
    #will only allow running this is the config is non null
    req(config)
    #the required checks have to return true
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
  #prints out notifications to the reserved spot
  output$savedConfig <- renderPrint({
    config <- currentConfig()
    #will only allow running this is the config is non null
    req(config)
    #the required checks have to return true
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
#links together these elements and allows them to display and work together
shinyApp(
  ui = ui,
  server = server
)