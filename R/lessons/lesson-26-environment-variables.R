Sys.setenv(
  METAWORKS_JOB_ID = "MW-2026-002",
  METAWORKS_MEMORY_GB = "10"
)

jobID <- Sys.getenv("METAWORKS_JOB_ID")
mem <- as.integer(Sys.getenv("METAWORKS_MEMORY_GB"))

print(jobID)
print(mem)

externalID <- system2(
  command = "printenv",
  args = "METAWORKS_JOB_ID",
  stdout = TRUE
)

print(externalID)

Sys.unsetenv(c("METAWORKS_JOB_ID", "METAWORKS_MEMORY_GB"))

