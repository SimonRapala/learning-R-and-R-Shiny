checkOverlap <- function(overlap) {
  message("Checking overlap...")

  if (is.na(overlap)) {
    stop("Overlap cannot be missing!")
  }

  if (overlap < 25) {
    warning("Overlap is below the recommended minimum.")
  }

  message("Overlap check completed.")

  return(TRUE)
}

safeCheckOverlap <- function(overlap) {
  #this catches any errors throw by a function
  #allows graceful dealing with errors in code
  result <- tryCatch(
    #the expression is the code being run
    {
      checkOverlap(overlap)
      "Validation completed"
    },
    #error here is what is printed when the stop() halts the program
    error = function(error) {
      paste(
        "Validation failed:",
        conditionMessage(error)
      )
    },
    #can write other ones for other messages however they dont halt program so unneeded
    warning = function(warning){
      paste(
        "Warning Outside: ", conditionMessage(warning)
      )
    }
  )

  return(result)
}


print(safeCheckOverlap(30))
print(safeCheckOverlap(20))
print(safeCheckOverlap(NA))

print("The script is still running.")