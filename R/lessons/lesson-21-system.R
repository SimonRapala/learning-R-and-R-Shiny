#Structure
# system2(
#   command = "program",
#   args = c("argument1", "argument2")
# )

workingDir <- system2(
  command = "pwd",
  stdout = TRUE
)


files <- system2(
  command = "ls",
  args = "-1",
  stdout = TRUE
)

whoAmI <- system2(
  command = "whoami",
  stdout = TRUE
)


print(workingDir)
print(files)
print(whoAmI)
