fileNames <- c("BR_R1_001.fastq.gz", "BR_R2_001.fastq.gz", "BR_R1_002.fastq.gz", "BR_R1_003.fastq.gz", "adapters.fasta")

#Removes any non-fastq files
onlyFastQBool <- grepl("\\.fastq\\.gz", fileNames)
onlyFastQ <- fileNames[onlyFastQBool]
# print(onlyFastQBool)
#print(onlyFastQ)


#Separate R1 and R2
onlyFwdReadsBool <- grep("_R1_", onlyFastQ)
onlyRevReadsBool <- grep("_R2_", onlyFastQ)
#Separated
onlyFwdReads <- onlyFastQ[onlyFwdReadsBool]
onlyRevReads <- onlyFastQ[onlyRevReadsBool]




#The expected reverse read for files
expectedRevReads <- sub("_R1_", "_R2_", onlyFwdReads)
#print(expectedRevReads)
hasReversePair <- expectedRevReads %in% onlyRevReads

pairs <- data.frame(
  fwdRead = onlyFwdReads[hasReversePair],
  revRead = onlyRevReads[hasReversePair]
)
print(pairs)

#Only 001
only001Bool <- grepl("001", onlyFastQ)
only001 <- onlyFastQ[only001Bool]
print(only001)