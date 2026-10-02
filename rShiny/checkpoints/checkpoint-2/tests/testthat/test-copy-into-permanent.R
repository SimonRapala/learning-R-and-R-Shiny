test_that("uploaded files are copied into the job inputs directory", {
  temporaryRoot <- withr::local_tempdir(
    pattern = "metaworks-copy-test-"
  )
  uploadDirectory <- file.path(temporaryRoot, "uploads")
  jobDirectory <- file.path(temporaryRoot, "job")
  dir.create(uploadDirectory)
  dir.create(jobDirectory)

  fastQPaths <- file.path(
    uploadDirectory,
    c(
      "temporary-fastq-1",
      "temporary-fastq-2"
    )
  )
  adapterPath <- file.path(
    uploadDirectory,
    "temporary-adapter"
  )

  writeLines("forward read", fastQPaths[1])
  writeLines("reverse read", fastQPaths[2])
  writeLines("adapter", adapterPath)

  fastQUpload <- makeUploadData(
    paths = fastQPaths,
    names = c(
      "BR5_1_R1_001.fastq.gz",
      "BR5_1_R2_001.fastq.gz"
    ),
    types = rep("application/gzip", 2)
  )
  adapterUpload <- makeUploadData(
    paths = adapterPath,
    names = "adapters.fasta",
    types = "text/plain"
  )

  copiedPaths <- copyIntoPermanent(
    fastQUpload,
    adapterUpload,
    jobDirectory
  )

  expectedPaths <- file.path(
    jobDirectory,
    "inputs",
    c(
      "BR5_1_R1_001.fastq.gz",
      "BR5_1_R2_001.fastq.gz",
      "adapters.fasta"
    )
  )

  expect_equal(copiedPaths, expectedPaths)
  expect_true(all(file.exists(copiedPaths)))
  expect_equal(readLines(copiedPaths[1]), "forward read")
  expect_equal(readLines(copiedPaths[2]), "reverse read")
  expect_equal(readLines(copiedPaths[3]), "adapter")
})

test_that("copying requires an existing job directory", {
  temporaryRoot <- withr::local_tempdir(
    pattern = "metaworks-missing-job-test-"
  )

  emptyUpload <- data.frame(
    name = character(0),
    size = numeric(0),
    type = character(0),
    datapath = character(0)
  )

  expect_error(
    copyIntoPermanent(
      emptyUpload,
      emptyUpload,
      file.path(temporaryRoot, "missing-job")
    ),
    "Directory Does Not Exist"
  )
})

test_that("copying fails when an uploaded source file is missing", {
  temporaryRoot <- withr::local_tempdir(
    pattern = "metaworks-missing-source-test-"
  )
  jobDirectory <- file.path(temporaryRoot, "job")
  dir.create(jobDirectory)

  missingUpload <- data.frame(
    name = "BR5_1_R1_001.fastq.gz",
    size = 10,
    type = "application/gzip",
    datapath = file.path(temporaryRoot, "missing-upload"),
    stringsAsFactors = FALSE
  )
  adapterUpload <- data.frame(
    name = "adapters.fasta",
    size = 10,
    type = "text/plain",
    datapath = file.path(temporaryRoot, "missing-adapter"),
    stringsAsFactors = FALSE
  )

  expect_error(
    copyIntoPermanent(
      missingUpload,
      adapterUpload,
      jobDirectory
    ),
    "One or more files could not be copied"
  )
})
