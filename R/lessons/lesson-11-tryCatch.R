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
  result <- tryCatch(
    {
      checkOverlap(overlap)
      "Validation completed"
    },
    error = function(error) {
      paste(
        "Validation failed:",
        conditionMessage(error)
      )
    },
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