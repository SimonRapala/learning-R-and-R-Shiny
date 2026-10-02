appEnvironment <- new.env(
  parent = globalenv()
)

sys.source(
  testthat::test_path("..", "..", "app.R"),
  envir = appEnvironment
)

filePairingVerification <- appEnvironment$filePairingVerification
createJobsDir <- appEnvironment$createJobsDir
copyIntoPermanent <- appEnvironment$copyIntoPermanent
server <- appEnvironment$server
