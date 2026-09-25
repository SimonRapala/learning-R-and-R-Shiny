# Data Frames act as a table
sampleNames <- c("BR5_1", "BR5_2", "BR5_3", "BR5_4")
readCounts <- c(83000, 125000, 64000, 141000)
passedFiltering <- c(TRUE, TRUE, FALSE, TRUE)

# Each value is a column in a table taking on the name it equals
# each column needs same amount of entries
sampleResults <- data.frame(
  sampleName = sampleNames,
  readCount = readCounts,
  passedFiltering = passedFiltering
)

# print(sampleResults)
# print(sampleResults$sampleName)

# print(sampleResults[["passedFiltering"]])

# print(sampleResults[2, ])

# print(sampleResults[, 2])

# print(sampleResults[3, 2])

# print(sampleResults[c(1, 4), c("sampleName", "readCount")])

# class(sampleResults["readCount"])

# class(sampleResults[["readCount"]])

#different ways to access different values
print(sampleResults)
print(sampleResults$sampleName)
print(sampleResults[3, ])
print(sampleResults[2, 2])
print(sampleResults[c(1, 3), ])
print(sampleResults[c(2, 4), c("sampleName", "passedFiltering")])
print(sampleResults["readCount"])
print(sampleResults[["readCount"]])
print(sampleResults[c(4, 1), c("readCount", "sampleName")])
