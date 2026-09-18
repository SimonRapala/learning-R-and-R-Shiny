# structure of functions#
# functionName <- function(argument1, argument2) {
# Code that uses the arguments
#   return(result)
# }


# validateSetting <- function(value, min, max) {
#   if (value >= min && value <= max) {
#     return(TRUE)
#   } else {
#     return(FALSE)
#   }
# }

# print(validateSetting(25, 10, 100))
# print(validateSetting(2, 4, 64))
# print(validateSetting(40, 0, 40))


# Also can have default arguments

createRunSettings <- function(
  overlap = 25,
  quality = 20,
  memoryGB = 10
) {
  return(
    list(
      overlap = overlap,
      quality = quality,
      memoryGB = memoryGB
    )
  )
}


print(createRunSettings())

print(createRunSettings(memoryGB = 12))

print(createRunSettings(
  overlap = 30,
  quality = 25,
  memoryGB = 16
))
