filenames <- c(
  "BR5_1_R1_001.fastq.gz",
  "BR5_1_R2_001.fastq.gz",
  "BR5_2_R1_001.fastq.gz",
  "BR5_2_R2_001.fastq.gz",
  "BR5_3_R1_001.fastq.gz",
  "BR5_4_R2_001.fastq.gz",
  "adapters.fasta",
  "results.csv"
)


inspectFastqFiles <- function(filenames) {
  message("Files are being inspected")
  if (missing(filenames) || is.null(filenames) || length(filenames) == 0) {
    stop("No files were provided.")
  }
  # Returned cleaned files
  fastQFiles <- returnFastQ(filenames)
  # If no files came back stop error
  if (length(fastQFiles) == 0) {
    stop("No FASTQ files were found.")
  }

  # returns the vector of FWD reads
  resultsFwdRead <- returnFwdRead(fastQFiles)
  # Saves the FWD and REV reads
  fwdReadFastQ <- fastQFiles[resultsFwdRead]
  revReadFastQ <- fastQFiles[!resultsFwdRead]
  # Gets what files are needed to create pairs
  expectedRevReads <- sub("_R1_", "_R2_", fwdReadFastQ)
  expectedFwdReads <- sub("_R2_", "_R1_", revReadFastQ)
  cat("Forward Read: ", fwdReadFastQ, "\n")
  cat("Reverse Read: ", revReadFastQ, "\n")
  cat("Expected Forward Read: ", expectedFwdReads, "\n")
  cat("Expected Reverse Read: ", expectedRevReads, "\n")

  # combines the expected values together
  expectedFiles <- c(expectedFwdReads, expectedRevReads)
  for (read in expectedFiles) {
    # compares each expected file to the ones actually given
    if (read %in% fwdReadFastQ || read %in% revReadFastQ) {
      cat(read, " is present in the reads \n")
    } else {
      cat(read, " is missing from reads \n")
    }
  }

  # If the expected reads are in the read lists
  hasRevPair <- expectedRevReads %in% revReadFastQ
  hasFwdPair <- expectedFwdReads %in% fwdReadFastQ

  pairedFwdReads <- fwdReadFastQ[hasRevPair]
  pairedRevReads <- expectedRevReads[hasRevPair]

  missingFwdReads <- expectedFwdReads[!hasFwdPair]
  missingRevReads <- expectedRevReads[!hasRevPair]

  for (missingRead in missingRevReads) {
    warning(missingRead, " is missing.")
  }

  for (missingRead in missingFwdReads) {
    warning(missingRead, " is missing.")
  }

  pairs <- data.frame(
    forwardRead = pairedFwdReads,
    reverseRead = pairedRevReads
  )

  message("Files were inspected.")

  return(
    list(
      pairs = pairs,
      missingR1 = missingFwdReads,
      missingR2 = missingRevReads,
      sampleCount = nrow(pairs)
    )
  )
}


# Returns just the FastQ files no other ones
returnFastQ <- function(filenames) {
  resultsFastQ <- grepl("\\.fastq\\.gz$", filenames)
  return(filenames[resultsFastQ])
}

returnFwdRead <- function(fastQFiles) {
  return(grepl("_R1_", fastQFiles))
}

inspection <- inspectFastqFiles(filenames)

print(inspection)
