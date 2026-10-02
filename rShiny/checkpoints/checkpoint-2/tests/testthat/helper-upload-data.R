makeUploadData <- function(paths, names, types) {
  data.frame(
    name = names,
    size = unname(file.info(paths)$size),
    type = types,
    datapath = paths,
    stringsAsFactors = FALSE
  )
}
