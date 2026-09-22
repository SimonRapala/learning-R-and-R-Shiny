createDir <- function(path) {
  if (!dir.exists(path)) {
    dir.create(path, recursive = TRUE)
  } else {
    stop("Directory Exists")
  }
}

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
    unlink(newPath, recursive = TRUE)
    paste("Error: ", conditionMessage(error))
  }
)

print(result)
