#gets the working directory
practicePath <- getwd()
#data frame that holds rows of info of different samples
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
#creates a filepath, and a file in it that is a csv, string
csvPath <- file.path(
  practicePath,
  "sample_results.csv"
)

#writes the data frame into the csv, makes csv
write.csv(
  sampleResults,
  csvPath,
  row.names = FALSE
)
#reads the csv into that variable
loadedResults <- read.csv(csvPath)

print(loadedResults[2,1])
print(loadedResults[3,2])
count <- 0
#for loop that prints the third column of every row
for (i in seq_len(nrow(loadedResults))){
  if (loadedResults[i, 3]){
    print(loadedResults[i, ])
  }
  #sums everything
  count <- count + loadedResults[i, 2]
}
print(count)