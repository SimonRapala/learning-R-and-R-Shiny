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


commonTaxa <- function(results) {
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


createReadsChart <- function(sampleReads) {
  graph <- ggplot2::ggplot(
    data = sampleReads,
    mapping = ggplot2::aes(
      x = SampleName,
      y = totalCounts
    )
  ) +
    ggplot2::geom_col() +
    ggplot2::labs(
      title = "Total Reads Per Sample",
      x = "Sample",
      y = "Total Reads"
    )
  return(graph)
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
readSampleGraph <- readsPerSample(results)
print(readSampleGraph)
taxaInfoCount <- countTaxonomicInfo(results)
print(taxaInfoCount)
filteredData <- confidenceScore(results = results, confidenceThreshold = 0.90)
commonTaxanomic <- commonTaxa(filteredData)
print(commonTaxanomic)
barGraphSamples <- createReadsChart(readSampleGraph)

outputDirectory <- file.path(getwd(), "output")

if (!dir.exists(outputDirectory)) {
  dir.create(outputDirectory)
}

chartPath <- file.path(
  outputDirectory,
  "reads_per_sample.pdf"
)

ggplot2::ggsave(
  filename = chartPath,
  plot = barGraphSamples,
  width = 8,
  height = 5
)

readr::write_csv(
  readSampleGraph,
  file.path(outputDirectory, "reads_per_sample.csv")
)

readr::write_csv(
  taxaInfoCount,
  file.path(outputDirectory, "taxonomic_counts.csv")
)

readr::write_csv(
  commonTaxanomic,
  file.path(outputDirectory, "common_taxa.csv")
)

