minimumOverlap <- 25
marker <- "COI"
usePseudogeneFilter <- TRUE

sampleName <- "COI_1_1_BR5"
fwdRead <- 125000
revRead <- 123500
primersFound <- TRUE

class(sampleName)
class(fwdRead)
class(primersFound)

minimumOverlap <- 30
totalRawReads <- fwdRead + revRead
cat("Total Reads: ", totalRawReads, "\nOverlap of: ", minimumOverlap, "\n")