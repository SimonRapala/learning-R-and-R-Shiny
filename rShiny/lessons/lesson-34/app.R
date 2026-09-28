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
  #an output box that will display a message
  textOutput(
    #output box ID
    outputId = "greeting"
  )
)

#sits idle until a change it made to the interface
#then updates all the code inside this function, will reactively display
server <- function(input, output, session) {
  #when this runs will write the text in that function to the greeting ID
  output$greeting <- renderText({
    paste(
      "Welcome, ",
      #gets this IDs input and pastes into the output
      input$userName, ". Welcome to MetaWorks!"
    )
  })
}

shinyApp(
  ui = ui,
  server = server
)