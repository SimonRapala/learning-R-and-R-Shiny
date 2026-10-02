createUniqueJob <- function(
  jobsRoot,
  projectName
) {
  # Create jobsRoot if it does not exist
  if (!dir.exists(jobsRoot)) {
    rootStatus <- dir.create(
      jobsRoot,
      recursive = TRUE
    )

    if (!rootStatus) {
      stop("Jobs root creation failed.")
    }
  }

  # Remove leading and trailing spaces
  projectName <- trimws(projectName)

  # Replace unsafe characters with hyphens
  projectName <- gsub(
    pattern = "[^A-Za-z0-9_-]+",
    replacement = "-",
    x = projectName
  )

  # Remove hyphens from the beginning or end
  projectName <- gsub(
    pattern = "^-+|-+$",
    replacement = "",
    x = projectName
  )

  if (projectName == "") {
    stop("Project name contains no usable characters.")
  }

  # Create a readable prefix
  jobPrefix <- paste0(
    projectName,
    "-",
    format(
      Sys.time(),
      "%Y-%m-%d_%H-%M-%S"
    ),
    "-"
  )

  # Generate a unique unused path
  jobPath <- tempfile(
    pattern = jobPrefix,
    tmpdir = jobsRoot
  )

  # Create the actual directory
  directoryStatus <- dir.create(jobPath)

  if (!directoryStatus) {
    stop("Directory creation failed.")
  }

  return(jobPath)
}