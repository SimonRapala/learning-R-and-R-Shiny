
mockResults <- data.frame(
  GlobalESV = c(
    "Zotu1", "Zotu2", "Zotu1",
    "Zotu3", "Zotu4", "Zotu2"
  ),
  SampleName = c(
    "BR5_1", "BR5_1", "BR5_2",
    "BR5_2", "BR5_3", "BR5_3"
  ),
  ESVsize = c(
    120, 45, 90, 30, 70, 65
  ),
  Phylum = c(
    "Arthropoda", "Arthropoda", "Arthropoda",
    "Annelida", "Arthropoda", "Arthropoda"
  ),
  Genus = c(
    "Baetis", NA, "Baetis",
    "Lumbricus", "Chironomus", NA
  ),
  Species = c(
    "Baetis_tricaudatus", NA,
    "Baetis_tricaudatus",
    "Lumbricus_terrestris",
    "Chironomus_riparius", NA
  ),
  sBP = c(
    0.98, NA, 0.98,
    0.82, 0.91, NA
  )
)

resultsPath <- file.path(
  getwd(),
  "mock_results.csv"
)

write.csv(
  mockResults,
  resultsPath,
  row.names = FALSE
)

results <- read.csv(resultsPath)

#lesson 1
# print(results)
# print(names(results))
# print(nrow(results))
# print(ncol(results))
# print(results[1:3, ])
# print(class(results$ESVsize))
# print(class(results$sBP))
# print(str(results))


#lesson 2
# uniqueSamples <- unique(results$SampleName)
# sampleCount <- length(uniqueSamples)

# uniqueESVs <- unique(results$GlobalESV)
# esvCount <- length(uniqueESVs)

# totalReads <- sum(results$ESVsize)

# cat(
#   "Unique samples:", uniqueSamples,
#   "\nSample count:", sampleCount,
#   "\nUnique ESVs:", uniqueESVs,
#   "\nESV count:", esvCount,
#   "\nTotal reads:", totalReads,
#   "\n")

#lesson 3