#' Source all .R files under data-raw/
#'
#' Usually we work on one dataset only, and don't know if our change impacted
#' other datasets. This function helps "refresh" all datasets at once. It may
#' be used interactively while developing the package, or in CI to regularly
#' check we can reproduce all datasets we export, and that the result is
#' consistent with our regression tests.
#'
#' @return `invisible()`, as it's called for its side effect.
#' @keywords internal
#'
#' @examples
#'source_data_raw()
#' @noRd
source_data_raw <- function() {
  # The `pattern` argument creates paths with "//"
  all <- list.files("data-raw", full.names = TRUE)
  r <- grep("[.]R$", all, value = TRUE)

  lapply(r, source)
  invisible()
}
