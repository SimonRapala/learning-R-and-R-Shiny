# checkMemory <- function(memoryGB) {
#   message("Checking memory setting...")

#   if (is.na(memoryGB)) {
#     stop("Memory cannot be missing.")
#   }

#   if (memoryGB < 10) {
#     warning("The classifier may not have enough memory.")
#   }

#   message("Memory check completed.")

#   return(TRUE)
# }

# checkMemory(12)
# checkMemory(8)
# checkMemory(NA)

#Messages are great for giving the user information or debugging
checkOverlap <- function(overlap) {
  message("Checking overlap ...")

  if (is.na(overlap)){
    #Stop is good for throwing an error that can give specific info to user
    stop("Overlap cannot be missing!")
  }
  if (overlap < 25){
    #Warning gives info to user but does not halt program
    warning("Overlap is below the recommended minimum.")
  }

  message("Overlap check completed.")

  return(TRUE)
}

checkOverlap(30)
checkOverlap(20)
checkOverlap(NA)