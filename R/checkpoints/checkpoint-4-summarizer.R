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



reportCSV <- function(results) {
  # Unique number of samples
  uniqueSamples <- unique(
    results$SampleName
  )
  # Unique ESVs
  uniqueESVs <- unique(
    results$GlobalESV
  )
  totalReads <- sum(results$ESVsize)

  report <- data.frame(
    uniqueSamplesCount = length(uniqueSamples),
    uniqueESVsCount = length(uniqueESVs),
    totalReads = totalReads
  )

  return(report)
}


readsPerSample <- function(results) {
  # Group by sample
  sampleGroups <- dplyr::group_by(
    .data = results,
    SampleName
  )
  countPerSample <- dplyr::summarise(
    .data = sampleGroups,
    totalCounts = sum(ESVsize),
    .groups = "drop"
  )
  return(countPerSample)
}


countTaxonomicInfo <- function(results) {
  taxonomicCount <- dplyr::summarise(
    .data = results,
    PhylumCount = sum(!is.na(Phylum)),
    GenusCount = sum(!is.na(Genus)),
    SpeciesCount = sum(!is.na(Species))
  )

  return(taxonomicCount)
}


confidenceScore <- function(results,
                            confidenceThreshold) {
  passThreshold <- dplyr::filter(
    .data = results,
    !is.na(Species),
    sBP >= confidenceThreshold
  )
  return(passThreshold)
}


commonTaxa <- function(results){
  groupedData <- dplyr::group_by(
    .data = results,
    Species
  )
  cleanedGroupedData <- dplyr::summarise(
    .data = groupedData,
    totalReads = sum(ESVsize),
    .groups = "drop"
  )

  sortedSpecies <- dplyr::arrange(
    .data = cleanedGroupedData,
    dplyr::desc(totalReads)
  )
  return(sortedSpecies)
}



resultsPath <- file.path(
  getwd(),
  "checkpointMock.csv"
)

write.csv(
  mockResults,
  resultsPath,
  row.names = FALSE
)

results <- read.csv(resultsPath)

print(reportCSV(results))
print(readsPerSample((results)))
print(countTaxonomicInfo((results)))
filteredData <- confidenceScore(results = results, confidenceThreshold = 0.90)
print(filteredData)
print(commonTaxa(filteredData))
