#requires external libraries
#format used for yaml files 
config <- list(
  workflow = "Default ESV",

  input = list(
    marker = "COI",
    samplePath = "inputs"
  ),

  SEQPREP = list(
    minimumOverlap = 25,
    minimumQuality = 13
  ),

  RDP = list(
    memory = "-Xmx10g",
    custom = "yes",
    classifier = "rRNAClassifier.properties"
  )
)
#creates the string fiel path for the yaml file
yamlPath <- file.path(
  getwd(),
  "config_runtime.yaml"
)
#writes the yaml file
yaml::write_yaml(
  config,
  yamlPath
)
#reads the yaml into a variable
loadedConfig <- yaml::read_yaml(yamlPath)
#the format used to write json files
runMetadata <- list(
  runID = "MW-2026-001",
  userName = "Simon",
  workflow = "Default ESV",
  marker = "COI",
  sampleNames = c(
    "BR5_1",
    "BR5_2",
    "BR5_3"
  ),
  classifier = "RDP COI v5.1",
  completed = TRUE
)
#makes json path string
jsonPath <- file.path(
  getwd(),
  "run_metadata.json"
)
#writes the json list into a json file
jsonlite::write_json(
  runMetadata,
  jsonPath,
  pretty = TRUE,
  auto_unbox = TRUE
)
#reads the json file into a variable
loadedMetadata <- jsonlite::read_json(
  jsonPath,
  simplifyVector = TRUE
)
#access parts from the read json
print(loadedConfig$SEQPREP$minimumOverlap)
print(loadedConfig$RDP$memory)
print(loadedMetadata$runID)
print(length(loadedMetadata$sampleNames))
print(loadedMetadata$completed)