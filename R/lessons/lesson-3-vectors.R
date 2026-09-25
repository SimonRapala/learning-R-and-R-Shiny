# readCounts <- c(83000, 120000, 47000, 205000)
# sampleNames <- c("COI_1", "COI_2", "COI_3", "COI_4")
# passedFilter <- c(TRUE, TRUE, FALSE, TRUE)

# print(readCounts)
# print(sampleNames)
# print(passedFilter)

# class(readCounts)
# length(readCounts)

# sum(readCounts)
# mean(readCounts)
# min(readCounts)
# max(readCounts)

# readCountThousands <- readCounts/1000
# print(readCountThousands)
# sum(passedFilter)

# mixedValues <- c(25, "COI", TRUE)
# print(mixedValues)
# class(mixedValues)

#vectors are similar to arrays in that they store same type of value
sampleNames <- c("BR5_1", "BR5_2", "BR5_3", "BR5_4", "BR5_5")
readCounts <- c(83000, 125000, 64000, 141000, 97000)
passedFiltering <- c(TRUE, TRUE, FALSE, TRUE, TRUE)
cat("Sample Names: ", sampleNames, "\nRead Count: ", readCounts,
    "\nPassed Filtering: ", passedFiltering, "\n")
#have built in operations that work on every index
sampleCount <- length(sampleNames)
totalReads <- sum(readCounts)
avgReads <- mean(readCounts)
maxRead <- max(readCounts)
passedCount <- sum(passedFiltering)

#nocely formats the print
cat("Sample Count: ", sampleCount,
    "\nTotal Reads: ", totalReads,
    "\nAverage Reads: ", avgReads,
    "\nHighest Read: ", maxRead,
    "\nPassed Count: ", passedCount, "\n")