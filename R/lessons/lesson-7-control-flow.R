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

#general control flow for a program. Basic true or false statement that decides what path is taken
if (readCount >= 100000) {
  print("High")
  #a specific other outcome
} else if (readCount >= 50000) {
  print("Acceptable")
  #covers all other outcomes
} else {
  print("Low")
}
#use of and. Both statements have to be true
if (classifierSelected && adapterSelected) {
  print("Ready To Run")
} else {
  print("Missing Required Files")
}
#if either statements are true then it runs the code
if (memoryGB < 10 || sampleCount > 100) {
  print("Resource Warning")
} else {
  print("Resources Acceptable")
}
