# Creates initial directories
createJobDirectories <- function(
  jobsRoot,
  runID
) {
  # Constructing job directory
  pathJobDir <- file.path(jobsRoot, runID)
  # Subdirectories
  pathInputsDir <- file.path(jobsRoot, runID, "inputs")
  pathLogsDir <- file.path(jobsRoot, runID, "logs")
  pathConfigsDir <- file.path(jobsRoot, runID, "configs")
  pathOutputsDir <- file.path(jobsRoot, runID, "output")

  if (dir.exists(pathJobDir)) {
    stop("Job Id Already Exists")
  }

  dir.create(pathJobDir, recursive = TRUE)
  dir.create(pathConfigsDir)
  dir.create(pathLogsDir)
  dir.create(pathInputsDir)
  dir.create(pathOutputsDir)

  jobInfo <- list(
    job = pathJobDir,
    config = pathConfigsDir,
    inputs = pathInputsDir,
    output = pathOutputsDir,
    log = pathLogsDir
  )

  return(jobInfo)
}



copyInputFiles <- function(
  sampleFiles,
  adapterFile,
  inputDirectory
) {
  # Check if each source exists
  if (all(file.exists(sampleFiles)) && all(file.exists(adapterFile))) {
    fileVector <- c(sampleFiles, adapterFile)
  } else {
    stop("Missing A File")
  }

  if (!dir.exists(inputDirectory)) {
    stop("Directory Does Not Exist")
  }


  copySample <- file.copy(sampleFiles, inputDirectory)
  if (!all(copySample)) {
    stop("The sample copy failed")
  }
  copyAdapter <- file.copy(adapterFile, inputDirectory)
  if (!copyAdapter) {
    stop("The adapter copy failed")
  }

  copiedPaths <- file.path(inputDirectory, basename(fileVector))

  return(copiedPaths)
}



sourceDirectory <- tempfile(
  pattern = "uploaded-files-"
)

dir.create(sourceDirectory)

sampleFiles <- file.path(
  sourceDirectory,
  c(
    "BR5_1_R1_001.fastq.gz",
    "BR5_1_R2_001.fastq.gz"
  )
)

adapterFile <- file.path(
  sourceDirectory,
  "adapters.fasta"
)

file.create(sampleFiles)
file.create(adapterFile)




jobsRoot <- file.path(
  getwd(),
  "jobs"
)

jobPaths <- createJobDirectories(
  jobsRoot,
  "MW-2026-002"
)

copiedFiles <- copyInputFiles(
  sampleFiles,
  adapterFile,
  jobPaths$inputs
)

print(copiedFiles)

