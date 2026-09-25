createDir <- function(path) {
  if (!dir.exists(path)) {
    #creates directory in location and name passed in from user
    dir.create(path, recursive = TRUE)
  } else {
    #error handling
    stop("Directory Exists")
  }
}
#gets working directory
path <- getwd()
print(path)
dir.exists(path)
newPath <- file.path(path, "dirPractice")

result <- tryCatch(
  expr = {
    createDir(newPath)
    "Directory Created"
  },
  error = function(error) {
    #deletes the directory when ran and all sub folders inside directory
    unlink(newPath, recursive = TRUE)
    paste("Error: ", conditionMessage(error))
  }
)

print(result)
