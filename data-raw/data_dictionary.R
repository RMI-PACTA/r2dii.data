parent <- system.file("extdata", package = "r2dii.data")
paths <- list.files(parent, full.names = TRUE)

out <- lapply(
  paths,
  function(.x) {
    utils::read.csv(
      .x,
      colClasses = "character",
      na.strings = c("", "NA"),
      stringsAsFactors = FALSE
    )
  }
)
out <- Reduce(rbind, out)
out <- tibble::as_tibble(out[order(out$dataset, out$column), , drop = FALSE])

data_dictionary <- out
use_data(data_dictionary, overwrite = TRUE)
