successfulResult <- processx::run(
  command = "ls",
  args = getwd(),
  error_on_status = FALSE
)

failedResult <- processx::run(
  command = "ls",
  args = "/directory-that-does-not-exist",
  error_on_status = FALSE
)

if (successfulResult$status == 0) {
  print("Successful command passed")
} else {
  print("Successful command failed")
}

if (failedResult$status == 0) {
  print("Successful command passed")
} else {
  print("Successful command failed")
}