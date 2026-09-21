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


checkOverlap <- function(overlap) {
  message("Checking overlap ...")

  if (is.na(overlap)){
    stop("Overlap cannot be missing!")
  }
  if (overlap < 25){
    warning("Overlap is below the recommended minimum.")
  }

  message("Overlap check completed.")

  return(TRUE)
}

checkOverlap(30)
checkOverlap(20)
checkOverlap(NA)