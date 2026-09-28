library(shiny)

#outlines the possible inputs that can be used on the page
ui <- fluidPage(
  #a title
  titlePanel("MetaWorks Run Interface"),
  #text box that takes input
  textInput(
    #inputId is the identifier used for CSS and to extract stored value
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
  step = 1
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

  #an output box that will display a message
  textOutput(
    #output box ID
    outputId = "greeting"
  ),

  textOutput(
    outputId = "count"
  )
)

#sits idle until a change it made to the interface
#then updates all the code inside this function, will reactively display
server <- function(input, output, session) {
output$greeting <- renderText({
paste0(
"Welcome, ",
input$userName,
". Welcome to MetaWorks!"
)
})

output$count <- renderText(
  {paste0("Count: ", input$runPipeline)}
)
}

shinyApp(
  ui = ui,
  server = server
)