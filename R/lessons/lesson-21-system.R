#Structure
# system2(
#   command = "program",
#   args = c("argument1", "argument2")
# )
#runs in CLI pwd is the command
workingDir <- system2(
  command = "pwd",
  stdout = TRUE
)

#args are the arguments provided, multiple with c()
#stdout outputs ans into terminal
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
