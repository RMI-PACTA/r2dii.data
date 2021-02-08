round_dbl <- function(data, digits = 4L) {
  data[detect_dbl(data)] <- lapply(data[detect_dbl(data)], round, digits = digits)
  data
}

ceiling_dbl <- function(data) {
  data[detect_dbl(data)] <- lapply(data[detect_dbl(data)], ceiling)
  data
}

detect_dbl <- function(data) {
  unlist(lapply(data, is.double))
}
