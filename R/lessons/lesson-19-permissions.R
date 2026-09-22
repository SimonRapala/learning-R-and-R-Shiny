practiceDir <- tempfile(
  pattern = "permission-practice-"
)

dir.create(practiceDir)

configPath <- file.path(
  practiceDir,
  "config_ESV.yaml"
)

writeLines(
  c(
    "SEQPREP:",
    "  minimumOverlap: 25"
  ),
  configPath
)

Sys.chmod(
  configPath,
  mode = "0644"
)

print(file.info(configPath)$mode)

canRead <- file.access(
  configPath,
  mode = 4
) == 0

canWrite <- file.access(
  configPath,
  mode = 2
) == 0

canExecute <- file.access(
  configPath,
  mode = 1
) == 0

cat("Can read:", canRead, "\n")
cat("Can write:", canWrite, "\n")
cat("Can execute:", canExecute, "\n")

Sys.chmod(
  configPath,
  mode = "0755"
)

canExecute <- file.access(
  configPath,
  mode = 1
) == 0

cat(
  "Can execute after chmod:",
  canExecute,
  "\n"
)

unlink(
  practiceDir,
  recursive = TRUE
)