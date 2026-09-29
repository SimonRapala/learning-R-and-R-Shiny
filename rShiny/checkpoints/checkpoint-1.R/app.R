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
      
    )
  )

)