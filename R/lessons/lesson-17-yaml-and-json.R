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

yamlPath <- file.path(
  getwd(),
  "config_runtime.yaml"
)

yaml::write_yaml(
  config,
  yamlPath
)

loadedConfig <- yaml::read_yaml(yamlPath)

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

jsonPath <- file.path(
  getwd(),
  "run_metadata.json"
)

jsonlite::write_json(
  runMetadata,
  jsonPath,
  pretty = TRUE,
  auto_unbox = TRUE
)

loadedMetadata <- jsonlite::read_json(
  jsonPath,
  simplifyVector = TRUE
)

print(loadedConfig$SEQPREP$minimumOverlap)
print(loadedConfig$RDP$memory)
print(loadedMetadata$runID)
print(length(loadedMetadata$sampleNames))
print(loadedMetadata$completed)