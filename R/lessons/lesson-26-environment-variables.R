#Sets up variables that external programs can see and use
Sys.setenv(
  METAWORKS_JOB_ID = "MW-2026-002",
  METAWORKS_MEMORY_GB = "10"
)

jobID <- Sys.getenv("METAWORKS_JOB_ID")
mem <- as.integer(Sys.getenv("METAWORKS_MEMORY_GB"))

print(jobID)
print(mem)
#Other programs or scripts can see these like labels and use them
externalID <- system2(
  command = "printenv",
  args = "METAWORKS_JOB_ID",
  stdout = TRUE
)

print(externalID)
#remove them as env variables
Sys.unsetenv(c("METAWORKS_JOB_ID", "METAWORKS_MEMORY_GB"))

