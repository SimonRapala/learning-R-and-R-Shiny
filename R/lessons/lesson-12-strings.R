filenames <- c(
  "BR5_1_R1_001.fastq.gz",
  "BR5_1_R2_001.fastq.gz",
  "BR5_2_R1_001.fastq.gz",
  "BR5_2_R2_001.fastq.gz",
  "BR5_3_R1_001.fastq.gz",
  "adapters.fasta",
  "results.csv"
)
#searches vectors for string that have that pattern in them, 
#returns truth vector that matches 
fastQResults <- grepl("\\.fastq\\.gz$", filenames)
fastQ <- filenames[fastQResults]

fwdFastQResults <- grepl("_R1_", fastQ)
fwdFastQ <- fastQ[fwdFastQResults]
print(fwdFastQ)
#sub replaces a part of a string with another, good for checking for expected pair naem
expRevFastQ <- sub("_R1_", "_R2_", fwdFastQ)
print(expRevFastQ)
length(fwdFastQ)

for (revRead in expRevFastQ) {
  if (is.element(revRead, filenames)) {
    cat(revRead, "is present in filenames \n")
  } else {
    cat(revRead, "not in filenames \n")
  }
}
