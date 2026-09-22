practicePath <- getwd()
sampleResults <- data.frame(
  sampleName = c(
    "BR5_1",
    "BR5_2",
    "BR5_3"
  ),
  readCount = c(
    83000,
    125000,
    64000
  ),
  passedFiltering = c(
    TRUE,
    TRUE,
    FALSE
  )
)
csvPath <- file.path(
  practicePath,
  "sample_results.csv"
)

write.csv(
  sampleResults,
  csvPath,
  row.names = FALSE
)

loadedResults <- read.csv(csvPath)

print(loadedResults[2,1])
print(loadedResults[3,2])
count <- 0
for (i in seq_len(nrow(loadedResults))){
  if (loadedResults[i, 3]){
    print(loadedResults[i, ])
  }
  count <- count + loadedResults[i, 2]
}
print(count)