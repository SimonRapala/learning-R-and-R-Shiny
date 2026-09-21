cat("Working directory:", getwd(), "\n\n")

pathFromLessons <- "lesson-13-directories.R"

pathFromProject <- paste0(
  "R/lessons/",
  "lesson-13-directories.R"
)

absolutePath <- paste0(
  "/home/simonr/learning-R-and-R-Shiny/",
  "R/lessons/lesson-13-directories.R"
)

cat(
  "Path from lessons exists:",
  file.exists(pathFromLessons),
  "\n"
)

cat(
  "Path from project exists:",
  file.exists(pathFromProject),
  "\n"
)

cat(
  "Absolute path exists:",
  file.exists(absolutePath),
  "\n"
)