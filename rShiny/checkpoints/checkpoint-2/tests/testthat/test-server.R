test_that("Create Job stores uploads and records the job summary", {
  temporaryRoot <- withr::local_tempdir(
    pattern = "metaworks-server-test-"
  )
  withr::local_dir(temporaryRoot)

  uploadDirectory <- file.path(temporaryRoot, "uploads")
  dir.create(uploadDirectory)

  fastQPaths <- file.path(
    uploadDirectory,
    c("upload-1", "upload-2")
  )
  adapterPath <- file.path(uploadDirectory, "upload-3")
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

  shiny::testServer(server, {
    expect_null(jobSummary())

    session$setInputs(
      fastQFiles = fastQUpload,
      adapterFile = adapterUpload,
      createJob = 1
    )
    session$flushReact()

    summary <- jobSummary()

    expect_type(summary, "list")
    expect_true(dir.exists(summary$jobPath))
    expect_equal(
      dirname(summary$jobPath),
      file.path(
        temporaryRoot,
        "project",
        "jobs"
      )
    )
    expect_true(all(file.exists(summary$copiedFiles)))
    expect_equal(
      basename(summary$copiedFiles),
      c(
        "BR5_1_R1_001.fastq.gz",
        "BR5_1_R2_001.fastq.gz",
        "adapters.fasta"
      )
    )
    expect_match(
      summary$createdAt,
      "^[0-9]{4}-[0-9]{2}-[0-9]{2}_[0-9]{2}-[0-9]{2}-[0-9]{2}$"
    )
    expect_match(output$statusProgress, "Job Path:")
  })
})
