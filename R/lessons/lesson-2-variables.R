#<- is used to assign variables however = works too
#can assign numbers, strings, chars and more
minimumOverlap <- 25
marker <- "COI"
usePseudogeneFilter <- TRUE

sampleName <- "COI_1_1_BR5"
fwdRead <- 125000
revRead <- 123500
primersFound <- TRUE
#used to see the type of number found in the variable
class(sampleName)
class(fwdRead)
class(primersFound)
#can add them together and do other numeric operations on them
minimumOverlap <- 30
totalRawReads <- fwdRead + revRead
cat("Total Reads: ", totalRawReads, "\nOverlap of: ", minimumOverlap, "\n")