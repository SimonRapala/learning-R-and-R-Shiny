# Run this script from the project root
projectRoot <- getwd()

#creates a string that looks like a pathway tat can be 
#used to make a directory in a specific place
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

#these directories were not made just the string for them
#make with dir.create() or file.create()
cat("Lesson file exists:", file.exists(lessonFile), "\n")
cat("Job directory exists:", dir.exists(jobDirectory), "\n")