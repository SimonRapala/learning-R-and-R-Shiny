#vector
sampleNames <- c("BR5_1", "BR5_2", "BR5_3", "BR5_4")
readCounts <- c(83000, 125000, 64000, 141000)

#list
#stores different types of data bundled together
#can access specific values using $
runInfo <- list(
  runID = "MW-2026-001",
  userName = "Simon",
  workflow = "Default ESV",
  marker = "COI",
  sampleNames = sampleNames,
  readCounts = readCounts,
  Classifier = "RDP COI v5.1",
  minimumOverlap = 25,
  completed = TRUE,
  totalReads = sum(readCounts)
)

print(runInfo)
class(runInfo)
length(runInfo)
names(runInfo)
str(runInfo)
print(runInfo$runID)