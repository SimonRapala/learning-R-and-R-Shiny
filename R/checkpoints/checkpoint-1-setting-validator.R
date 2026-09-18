settings <- data.frame(
  settingNames = c("minimumOverlap", "minimumQuality", "memoryGB"),
  values = c(25, NA, 2),
  minimums = c(10, 0, 4),
  maximums = c(100, 40, 64),
  defaults = c(25, 20, 10)
)


print(settings)

for (i in seq_along(settings$values)) {
  # Validates and replaces NA values
  if (is.na(settings$values[i])) {
    settings$values[i] <- settings$default[i]
    cat(settings$defaults[i], "was applied\n")
  }

  if (settings$values[i] >= settings$minimums[i] &&
    settings$values[i] <= settings$maximums[i]) {
    cat(settings$settingNames[i], "is valid\n")
  } else {
    cat(
      "Warning:",
      settings$settingNames[i],
      "is outside the allowed range\n"
    )
  }
}
print(settings)
