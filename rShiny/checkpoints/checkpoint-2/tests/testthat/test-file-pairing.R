test_that("complete FASTQ pairs are matched", {
  files <- c(
    "BR5_1_R1_001.fastq.gz",
    "BR5_1_R2_001.fastq.gz",
    "BR5_2_R1_001.fastq.gz",
    "BR5_2_R2_001.fastq.gz"
  )

  result <- filePairingVerification(files)

  expect_equal(
    result$pairs,
    data.frame(
      fwdRead = c(
        "BR5_1_R1_001.fastq.gz",
        "BR5_2_R1_001.fastq.gz"
      ),
      revRead = c(
        "BR5_1_R2_001.fastq.gz",
        "BR5_2_R2_001.fastq.gz"
      )
    )
  )
  expect_length(result$missingR1, 0)
  expect_length(result$missingR2, 0)
})

test_that("missing R1 and R2 filenames are reported", {
  files <- c(
    "BR5_1_R1_001.fastq.gz",
    "BR5_1_R2_001.fastq.gz",
    "BR5_2_R1_001.fastq.gz",
    "BR5_3_R2_001.fastq.gz"
  )

  result <- filePairingVerification(files)

  expect_equal(nrow(result$pairs), 1)
  expect_equal(
    result$missingR1,
    "BR5_3_R1_001.fastq.gz"
  )
  expect_equal(
    result$missingR2,
    "BR5_2_R2_001.fastq.gz"
  )
})

test_that("an empty filename vector returns empty results", {
  result <- filePairingVerification(character(0))

  expect_equal(nrow(result$pairs), 0)
  expect_length(result$missingR1, 0)
  expect_length(result$missingR2, 0)
})
