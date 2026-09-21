applyDefault <- function(value, default) {
  if (is.na(value)) {
    return(default)
  }

  return(value)
}

isWithinRange <- function(value, minimum, maximum) {
  return(value >= minimum && value <= maximum)
}

validateSetting <- function(value, minimum, maximum, default) {
  finalValue <- applyDefault(value, default)
  valid <- isWithinRange(finalValue, minimum, maximum)

  return(
    list(
      value = finalValue,
      valid = valid
    )
  )
}

print(applyDefault(NA, 25))
print(applyDefault(30, 25))

print(isWithinRange(25, 10, 100))
print(isWithinRange(105, 10, 100))

print(validateSetting(NA, 10, 100, 25))
print(validateSetting(105, 10, 100, 25))