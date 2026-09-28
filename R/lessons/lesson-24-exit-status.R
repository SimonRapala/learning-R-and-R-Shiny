filePath <- tempfile(
  pattern = "hi-"
)

file.create(filePath)


reportCommandStatus <- function(status) {
  if (status == 0){
    return("Success")
  } else {
    error <- paste0("Failed with status: ", status)
    return(error)
  }
}

#if stdout is not present will return 0 for pass and nonzero for fail
goodOutput <- system2(
  command = "ls",
  args = shQuote(filePath)
)

badOutput <- system2(
  command = "ls",
  args = "hi"
)

print(reportCommandStatus(goodOutput))
print(reportCommandStatus(badOutput))