library(shiny)

samples <- data.frame(
  names = c("Simon", "Kevin", "Britany", "Carl"),
  scores = c(93, 55, 88, 100)
)

ui <- fluidPage(
  title = "Avg Test Scores",
  tableOutput(
    outputId = "spreadsheet"
  ),
  plotOutput(
    outputId = "barGraph"
  )
)


server <- function(input, output, session) {
  renderTable(
    samples
  )

  output$barGraph <- renderPlot(
    barplot(
      height = samples$scores,
      names.arg = samples$names,
      xlab = "Name",
      ylab = "Score",
      col = "red"
    )
  )

}

shinyApp(
  ui = ui,
  server = server
)