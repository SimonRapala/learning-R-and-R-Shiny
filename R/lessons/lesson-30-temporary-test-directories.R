# testthat::test_that("a file can be created in a temporary directory", {
#   testDirectory <- withr::local_tempdir(
#     pattern = "metaworks-test-"
#   )

#   testthat::expect_true(
#     dir.exists(testDirectory)
#   )

#   resultPath <- file.path(
#     testDirectory,
#     "results.csv"
#   )

#   writeLines(
#     c(
#       "sampleName,totalReads",
#       "BR5_1,125000"
#     ),
#     resultPath
#   )

#   testthat::expect_true(
#     file.exists(resultPath)
#   )

#   testthat::expect_equal(
#     readLines(resultPath),
#     c(
#       "sampleName,totalReads",
#       "BR5_1,125000"
#     )
#   )
# })


testthat::test_that(
  desc = "temp job file are created",
  code = {
    tempTestDir <- withr::local_tempdir(
      pattern = "metaworks-test-"
    )

    inputDirPath <- file.path(
      tempTestDir,
      "inputs"
    )

    logsDirPath <- file.path(
      tempTestDir,
      "logs"
    )
    dir.create(inputDirPath)
    dir.create(logsDirPath)

    adaptersFilePath <- file.path(
      inputDirPath,
      "adapters.fasta"
    )

    writeLines(
      c(
        ">forward_primer",
        "ACGTACGT"
      ),
      adaptersFilePath
    )

    testthat::expect_true(
      dir.exists(inputDirPath) && dir.exists(logsDirPath) && file.exists(adaptersFilePath)
    )

    readFastaLines <- readLines(
      adaptersFilePath
    )

    testthat::expect_equal(
      readFastaLines,
      c(
        ">forward_primer",
        "ACGTACGT"
      )
    )
  }
)
