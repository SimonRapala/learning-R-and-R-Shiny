temporaryRoot <- tempdir()

cat("R temporary directory:", temporaryRoot, "\n")
cat("Directory exists:", dir.exists(temporaryRoot), "\n")

temporaryJob <- tempfile(pattern = "metaworks-job-")

cat("Proposed job path:", temporaryJob, "\n")
cat("Exists before creation:", dir.exists(temporaryJob), "\n")

dir.create(temporaryJob)

cat("Exists after creation:", dir.exists(temporaryJob), "\n")

adapterPath <- file.path(
  temporaryJob,
  "adapters.fasta"
)

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

unlink(
  temporaryJob,
  recursive = TRUE
)

cat(
  "Job directory exists after cleanup:",
  dir.exists(temporaryJob),
  "\n"
)