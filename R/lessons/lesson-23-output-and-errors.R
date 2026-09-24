standardOutputPath <- tempfile(
  pattern = "stdout-"
)
standardOutputPath2 <- tempfile(
  pattern = "stdout-"
)

standardErrorPath <- tempfile(
  pattern = "stderr-"
)
standardErrorPath2 <- tempfile(
  pattern = "stderr-"
)

missingFilePath <- file.path(
  getwd(),
  "missing-file.txt"
)

existingFilePath <- file.path(
  getwd(),
  "lesson-23-output-and-errors.R"
)

system2(
  command = "ls",
  args = shQuote(missingFilePath),
  stdout = standardOutputPath,
  stderr = standardErrorPath
)

system2(
  command = "ls",
  args = shQuote(existingFilePath),
  stdout = standardOutputPath2,
  stderr = standardErrorPath2
)



standardOutput <- readLines(
  standardOutputPath,
  warn = FALSE
)

standardError <- readLines(
  standardErrorPath,
  warn = FALSE
)

standardOutput2 <- readLines(
  standardOutputPath2,
  warn = FALSE
)

standardError2 <- readLines(
  standardErrorPath2,
  warn = FALSE
)

print(standardOutput)
print(standardError)
print(standardOutput2)
print(standardError2)