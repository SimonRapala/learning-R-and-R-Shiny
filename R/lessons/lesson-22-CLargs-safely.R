samplePath <- file.path(
  getwd(),
  "sample reads.txt"
)

writeLines(
  c(
    "read one",
    "read two",
    "read three"
  ),
  samplePath
)


firstLines <- system2(
  command = "head",
  args = c(
    "-n",
    "2",
    shQuote(samplePath)
  ),
  stdout = TRUE
)

print(firstLines)