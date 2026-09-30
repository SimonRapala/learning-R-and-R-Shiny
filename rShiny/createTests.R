testDirectory <- file.path(
  getwd(),
  "test-uploads"
)

dir.create(
  testDirectory,
  showWarnings = FALSE
)

createTestFastq <- function(path) {
  connection <- gzfile(
    path,
    open = "wt"
  )

  writeLines(
    c(
      "@test_read",
      "ACGTACGT",
      "+",
      "IIIIIIII"
    ),
    connection
  )

  close(connection)
}

createTestFastq(
  file.path(
    testDirectory,
    "BR5_1_R1_001.fastq.gz"
  )
)

createTestFastq(
  file.path(
    testDirectory,
    "BR5_1_R2_001.fastq.gz"
  )
)

writeLines(
  "This is not a FASTQ file.",
  file.path(
    testDirectory,
    "results.csv"
  )
)

print(list.files(
  testDirectory,
  full.names = TRUE
))