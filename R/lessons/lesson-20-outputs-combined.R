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

# lesson 1
# print(results)
# print(names(results))
# print(nrow(results))
# print(ncol(results))
# print(results[1:3, ])
# print(class(results$ESVsize))
# print(class(results$sBP))
# print(str(results))


# lesson 2
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

# lesson 3
# readResults <- dplyr::select(
#   results,
#   SampleName,
#   GlobalESV,
#   ESVsize
# )
# taxonomyResults <- dplyr::select(
#   .data = results,
#   GlobalESV,
#   Phylum,
#   Genus,
#   Species,
#   sBP
# )
# print(readResults)
# print(taxonomyResults)


# renamedResults <- dplyr::rename(
#   readResults,
#   sample = SampleName,
#   esv = GlobalESV,
#   readCount = ESVsize
# )

# print(renamedResults)
# names(renamedResults)

# highReadResults <- dplyr::filter(
#   renamedResults,
#   esv >= 70
# )

# # print(highReadResults)

# singleESV <- dplyr::filter(
#   .data = results,
#   SampleName == "BR5_1"
# )

# enoughSamples <- dplyr::filter(
#   .data = results,
#   ESVsize >= 50
# )

# arthropodaEnoughSamples <- dplyr::filter(
#   .data = results,
#   Phylum == "Arthropoda",
#   ESVsize >= 70
# )

# print(singleESV)
# print(enoughSamples)
# print(arthropodaEnoughSamples)

#lesson 4
# resultsBySample <- dplyr::group_by(
#   results,
#   SampleName
# )

# print(resultsBySample)



# sampleSummary <- dplyr::summarise(
#   resultsBySample,
#   totalReads = sum(ESVsize),
#   esvRecords = dplyr::n()
# )

# resultsPhylum <- dplyr::group_by(
#   .data = results,
#   Phylum
# )

# summarisedPhylum <- dplyr::summarise(
#   .data = resultsPhylum,
#   totalReads = sum(ESVsize),
#   esvRecords = dplyr::n(),
#   avgReads = mean(ESVsize)
# )

# print(resultsPhylum)
# print(summarisedPhylum)

#lesson 5
# distinctSampleNames <- dplyr::n_distinct(
#   results$SampleName
# )

# distinctSampleNamesExNA <- dplyr::n_distinct(
#   results$Genus,
#   na.rm = TRUE
# )

# numMissingGenus <- sum(
#   is.na(results$Genus)
# )

# missingGenus <- dplyr::filter(
#   .data = results,
#   is.na(Genus)
# )

# print(distinctSampleNames)
# print(distinctSampleNamesExNA)
# print(numMissingGenus)
# print(missingGenus)

#lesson 6
#groups data by chosen attribute
resultsBySample <- dplyr::group_by(
  results,
  SampleName
)
#collapses table based off grouping while performing operations
readsPerSample <- dplyr::summarise(
  resultsBySample,
  totalReads = sum(ESVsize),
  .groups = "drop"
)

print(readsPerSample)
#plot out a chart based of the filtered data and chosen attribute
#determines what info goes where and maps it
readsChart <- ggplot2::ggplot(
  data = readsPerSample,
  mapping = ggplot2::aes(
    x = SampleName,
    y = totalReads
  )
) +#makes it a bar graph with a blue color
  ggplot2::geom_col(
    fill = "steelblue"
  ) +
  #labels the chart to make it readable
  ggplot2::labs(
    title = "Total Reads per Sample",
    x = "Sample",
    y = "Total Reads"
  )

print(readsChart)