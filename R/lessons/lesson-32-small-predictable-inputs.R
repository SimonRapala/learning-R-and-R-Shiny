returnFastqFiles <- function(filenames) {
  isFastq <- grepl("\\.fastq\\.gz$", filenames)

  return(filenames[isFastq])
}

testthat::test_that("only FASTQ filenames are returned", {
  filenames <- c(
    "BR5_1_R1_001.fastq.gz",
    "BR5_1_R2_001.fastq.gz",
    "adapters.fasta",
    "results.csv"
  )

  vector1 <- c(
    "adapters.fasta",
    "results.csv"
  )

  vector2 <- c(
    "BR5_1_R2_007.fastq.gz",
    "BR5_1_R2_003.fastq.gz",
    "results.txt"
  )

  expectedFastqFiles <- c(
    "BR5_1_R1_001.fastq.gz",
    "BR5_1_R2_001.fastq.gz"
  )

  expectedFastqFilesVector2 <- c(
    "BR5_1_R2_007.fastq.gz",
    "BR5_1_R2_003.fastq.gz"
  )

  actualFastqFiles <- returnFastqFiles(filenames)
  fastQVector1 <- returnFastqFiles(vector1)
  fastQVector2 <- returnFastqFiles(vector2)

  testthat::expect_equal(
    fastQVector1,
    character(0)
  )

  testthat::expect_equal(
    fastQVector2,
    expectedFastqFilesVector2
  )

  testthat::expect_equal(
    actualFastqFiles,
    expectedFastqFiles
  )


})