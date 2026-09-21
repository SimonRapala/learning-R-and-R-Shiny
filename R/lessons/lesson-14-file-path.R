# Run this script from the project root
projectRoot <- getwd()

lessonFile <- file.path(
  projectRoot,
  "R",
  "lessons",
  "lesson-14-file-path.R"
)

jobID <- "MW-2026-001"

jobDirectory <- file.path(
  projectRoot,
  "jobs",
  jobID
)

inputDirectory <- file.path(
  jobDirectory,
  "input"
)

configDirectory <- file.path(
  jobDirectory,
  "configuration"
)

logDirectory <- file.path(
  jobDirectory,
  "logs"
)

outputDirectory <- file.path(
  jobDirectory,
  "output"
)

cat("Project root:", projectRoot, "\n")
cat("Lesson file:", lessonFile, "\n\n")

cat("Job directory:", jobDirectory, "\n")
cat("Input directory:", inputDirectory, "\n")
cat("Configuration directory:", configDirectory, "\n")
cat("Log directory:", logDirectory, "\n")
cat("Output directory:", outputDirectory, "\n\n")

cat("Lesson file exists:", file.exists(lessonFile), "\n")
cat("Job directory exists:", dir.exists(jobDirectory), "\n")