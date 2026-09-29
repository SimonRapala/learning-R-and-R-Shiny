library(shiny)

sampleResults <- data.frame(
  sampleName = c("BR5_1", "BR5_2", "BR5_3"),
  totalReads = c(83000, 125000, 64000),
  passedFiltering = c(TRUE, TRUE, FALSE)
)

# outlines the possible inputs that can be used on the page
ui <- fluidPage(
  # a title
  titlePanel("MetaWorks Run Interface"),
  # text box that takes input
  textInput(
    # inputId is the identifier used for CSS and to extract stored value
    inputId = "userName",
    label = "Enter your name:"
  ),
  checkboxInput(
    inputId = "pseudogeneFilter",
    label = "Use pseudogene filtering",
    value = TRUE
  ),
  numericInput(
    inputId = "memoryGB",
    label = "Memory (GB):",
    value = 10,
    min = 4,
    max = 64,
    step = 2
  ),
  selectInput(
    inputId = "marker",
    label = "Genetic marker:",
    choices = c("COI", "16S", "ITS"),
    selected = "COI"
  ),
  actionButton(
    inputId = "runPipeline",
    label = "Run MetaWorks"
  ),

  # an output box that will display a message
  textOutput(
    # output box ID
    outputId = "greeting"
  ),
  textOutput(
    outputId = "count"
  ),
  # makes a title for the chart
  h4("Sample Results"),
  # reserves a spot for the table chart
  tableOutput(
    outputId = "resultsTable"
  ),
  # makes a title for the bar graph
  h4("Reads Per Sample"),
  # reserves a spot for the bar graph
  plotOutput(
    outputId = "readsPlot"
  ),
  h2("Current Run Settings"),
  verbatimTextOutput(
    outputId = "settingsSummary"
  ),
  textOutput("runStatus")
)

# sits idle until a change it made to the interface
# then updates all the code inside this function, will reactively display
server <- function(input, output, session) {
  runSettings <- reactive({
    list(
      userName = input$userName,
      marker = input$marker,
      memoryGB = input$memoryGB,
      pseudogeneFilter = input$pseudogeneFilter
    )
  })


  output$greeting <- renderText({
    paste0(
      "Welcome, ",
      input$userName,
      ". Welcome to MetaWorks!"
    )
  })

  output$count <- renderText({
    paste0("Count: ", input$runPipeline)
  })

  # renders a table usign the data frame layout
  output$resultsTable <- renderTable({
    sampleResults
  })

  # renders a bar graph using names and total reads
  # also labels each axis and makes abrs a color
  # output$readsPlot <- renderPlot({
  #   barplot(
  #     height = sampleResults$totalReads,
  #     names.arg = sampleResults$sampleName,
  #     main = "Total Reads per Sample",
  #     xlab = "Sample",
  #     ylab = "Total Reads",
  #     col = "steelblue"
  #   )
  # })


  output$readsPlot <- renderPlot({
    readPercentages <- round(
      sampleResults$totalReads /
        sum(sampleResults$totalReads) * 100,
      digits = 1
    )

    sliceLabels <- paste0(
      sampleResults$sampleName,
      "\n",
      readPercentages,
      "%"
    )

    pie(
      x = sampleResults$totalReads,
      labels = sliceLabels,
      main = "Percentage of Reads per Sample",
      col = c(
        "steelblue",
        "darkorange",
        "seagreen"
      )
    )
  })

  output$settingsSummary <- renderPrint({
    runSettings()
  })


  runStatus <- reactiveVal("Not started")

  observeEvent(input$runPipeline, {
    runStatus("Run requested")
  })

  output$runStatus <- renderText({
    paste("Status:", runStatus())
  })
}

shinyApp(
  ui = ui,
  server = server
)
