# readCount <- 47000


# if (readCount >= 50000) {
#   print("Read Count Passed")
# } else {
#   print("Read Count Failed")
# }

# classifierSelected <- TRUE

# if (classifierSelected) {
#   print("Classifier is ready")
# } else {
#   print("Classifier Missing")
# }

readCount <- 72000
classifierSelected <- TRUE
adapterSelected <- FALSE
memoryGB <- 8
sampleCount <- 120

if (readCount >= 100000) {
  print("High")
} else if (readCount >= 50000) {
  print("Acceptable")
} else {
  print("Low")
}

if (classifierSelected && adapterSelected) {
  print("Ready To Run")
} else {
  print("Missing Required Files")
}

if (memoryGB < 10 || sampleCount > 100) {
  print("Resource Warning")
} else {
  print("Resources Acceptable")
}
