testVector <- c(
    "BR5_1_R1_001.fastq.gz",
    "BR5_1_R2_001.fastq.gz",
    "BR5_1_R1_002.fastq.gz",
    "BR5_1_R2_002.fastq.gz",
    "BR5_1_R2_010.fastq.gz",
    "adapters.fasta",
    "results.csv"
  )

isolateR1R2 <- function(vector){
  vectorBool <- grepl("\\.fastq\\.gz$", vector)
  return(vector[vectorBool])
}

pairedReadsRev <- function(vector){
  pairedVectorRev <- sub("_R1_", "_R2_", vector)
  return(pairedVectorRev)
}

pairedReadsFwd <- function(vector){
  pairedVectorFwd <- sub("_R2_", "_R1_", vector)
  return(pairedVectorFwd)
}

testthat::test_that(
  desc = "Identifying correct FASTQ files and reads",
  code = {
isolatedReads <- isolateR1R2(testVector)

testthat::expect_equal(
  isolatedReads,
  c(
    "BR5_1_R1_001.fastq.gz",
    "BR5_1_R2_001.fastq.gz",
    "BR5_1_R1_002.fastq.gz",
    "BR5_1_R2_002.fastq.gz",
    "BR5_1_R2_010.fastq.gz"
      )
    )

fwdReadsBool <- grepl("_R1_", isolatedReads)
fwdReads <- isolatedReads[fwdReadsBool]
revReadsBool <- grepl("_R2_", isolatedReads)
revReads <- isolatedReads[revReadsBool]

expectedFwd <- pairedReadsFwd(revReads)
expectedRev <- pairedReadsRev(fwdReads)

combinedExpected <- c(expectedFwd, expectedRev)

haveValues <- combinedExpected %in% testVector

testthat::expect_equal(
  haveValues,
  c(TRUE, TRUE, FALSE, TRUE, TRUE)
)

missingRead <- (combinedExpected[!haveValues])
testthat::expect_equal(
  missingRead,
  "BR5_1_R1_010.fastq.gz"
)


  }
)