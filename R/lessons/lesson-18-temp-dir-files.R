#creates a temp root during runtime that is cleaned up afterwards
temporaryRoot <- tempdir()

cat("R temporary directory:", temporaryRoot, "\n")
cat("Directory exists:", dir.exists(temporaryRoot), "\n")
#makes a file pathway with that name pattern
temporaryJob <- tempfile(pattern = "metaworks-job-")

cat("Proposed job path:", temporaryJob, "\n")
cat("Exists before creation:", dir.exists(temporaryJob), "\n")

dir.create(temporaryJob)

cat("Exists after creation:", dir.exists(temporaryJob), "\n")

adapterPath <- file.path(
  temporaryJob,
  "adapters.fasta"
)
#writes into a txt file 
writeLines(
  c(
    ">forward_primer",
    "ACGTACGT",
    ">reverse_primer",
    "TGCATGCA"
  ),
  adapterPath
)

cat("Adapter exists:", file.exists(adapterPath), "\n")
cat("Temporary files:\n")

print(
  list.files(
    temporaryJob,
    full.names = TRUE
  )
)
#ensures that the temp files are deleted after run
unlink(
  temporaryJob,
  recursive = TRUE
)

cat(
  "Job directory exists after cleanup:",
  dir.exists(temporaryJob),
  "\n"
)