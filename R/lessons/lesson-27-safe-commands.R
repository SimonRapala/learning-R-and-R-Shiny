practiceFilePath <- tempfile(
  pattern = "temp-"
)



writeLines(
  c(
    "Read 1: 100",
    "Read 2: 200",
    "Read 3: 300"
  ),
  practiceFilePath
)

firstLines <- system2(
  command = "head",
  args = c("-n", "2", shQuote(practiceFilePath)),
  stdout = TRUE
)

print(firstLines)
unlink(practiceFilePath)
