runMockPipeline <- function(
  scriptPath,
  mode,
  resultPath,
  logPath
) {
  if (!file.exists(scriptPath)) {
    stop("Script path does not exist")
  }

  mode <- tolower(mode)

  if (!(mode == "success" || mode == "failure")) {
    stop("Wrong Mode Passed")
  }

  result <- processx::run(
    command = "bash",
    args = c(
      scriptPath,
      mode,
      resultPath
    ),
    error_on_status = FALSE
  )

  logMessage <- c(
    c("Status: ", result$status), c("Stdout: ", result$stdout),
    c("Sterr: ", result$stderr), c("Timeout: ", result$timeout)
  )

  writeLines(logMessage, logPath)

  if (result$status == 0) {
    print("Pipeline completed successfully")
  } else {
    print("Pipeline failed")
  }

  return(result)
}

successfulRun <- runMockPipeline(
  scriptPath = "mock-pipeline.sh",
  mode = "success",
  resultPath = "mock-results.csv",
  logPath = "successful-run.log"
)

failedRun <- runMockPipeline(
  scriptPath = "mock-pipeline.sh",
  mode = "failure",
  resultPath = "failed-results.csv",
  logPath = "failed-run.log"
)
