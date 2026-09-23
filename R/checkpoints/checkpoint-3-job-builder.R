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


writeJobConfig <- function(
  config,
  configDirectory
) {
  if (!dir.exists(configDirectory)) {
    stop("Config Directory Does Not Exist")
  }

  if (!is.list(config)) {
    stop("Config Needs TO Be A List")
  }

  configYAMLPath <- file.path(configDirectory, "config_ESV.yaml")

  yaml::write_yaml(config, configYAMLPath, fileEncoding = "UTF-8")

  if (!file.exists(configYAMLPath)) {
    stop("File Creation Failed")
  } else {
    return(configYAMLPath)
  }
}



# Create temporary uploaded files
sourceDirectory <- tempfile("uploaded-files-")
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

file.create(sampleFiles, adapterFile)


# Create job directories
jobsRoot <- tempfile("jobs-")

jobPaths <- createJobDirectories(
  jobsRoot,
  "MW-2026-002"
)


# Copy input files
copiedFiles <- copyInputFiles(
  sampleFiles,
  adapterFile,
  jobPaths$inputs
)


# Create configuration
config <- list(
  workflow = "Default ESV",
  paths = list(
    inputs = jobPaths$inputs,
    output = jobPaths$output,
    adapters = file.path(
      jobPaths$inputs,
      "adapters.fasta"
    )
  ),
  SEQPREP = list(
    minimumOverlap = 25
  ),
  CUTADAPT = list(
    minimumQuality = 20
  ),
  RDP = list(
    memory = "-Xmx10g",
    custom = "yes",
    classifier =
      "/classifiers/COI/rRNAClassifier.properties"
  )
)

configPath <- writeJobConfig(
  config,
  jobPaths$config
)

loadedConfig <- yaml::read_yaml(configPath)


# Tests
stopifnot(
  all(dir.exists(unlist(jobPaths))),
  length(copiedFiles) == 3,
  all(file.exists(copiedFiles)),
  file.exists(configPath),
  loadedConfig$workflow == "Default ESV",
  loadedConfig$SEQPREP$minimumOverlap == 25,
  loadedConfig$CUTADAPT$minimumQuality == 20,
  loadedConfig$RDP$memory == "-Xmx10g"
)

print(jobPaths)
print(copiedFiles)
print(configPath)

message("All tests passed.")