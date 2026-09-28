library(shiny)

ui <- fluidPage(
  titlePanel("MetaWorks Run Interface"),

  textInput(
    inputId = "userName",
    label = "Enter your name:"
  ),

  textOutput(
    outputId = "greeting"
  )
)

server <- function(input, output, session) {
  output$greeting <- renderText({
    paste(
      "Welcome, ",
      input$userName, ". Welcome to MetaWorks!"
    )
  })
}

shinyApp(
  ui = ui,
  server = server
)