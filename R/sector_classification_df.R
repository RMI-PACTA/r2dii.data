#' A view of available sector classification datasets
#'
#' @seealso [data_dictionary()].
#' @family datasets for bridging sector classification codes
#'
#' @return A [tibble::tibble()]. The column `code_system` names one of the
#'   classification systems that 2dii uses. All other columns are defined at
#'   [data_dictionary()].
#'
#' @export
#'
#' @examples
#' sector_classification_df()
#'
#' dd <- data_dictionary()
#' dd[grepl("_classification", dd$dataset), ]
sector_classification_df <- function() {
  out <- enlist_datasets("r2dii.data", pattern = "_classification$")
  out <- purrr::imap(out, ~ transform(.x, code_system = toupper(.y)))
  out <- purrr::map(out, ~ .x[c("sector", "borderline", "code", "code_system")])
  # Coerce every column to character for more robust reduce() and join()
  out <- purrr::map(out, ~ purrr::modify(.x, as.character))
  # Collapse the list of dataframes to a single, row-bind dataframe
  out <- purrr::reduce(out, rbind)
  out <- unique(purrr::modify_at(out, "borderline", as.logical))

  tibble::as_tibble(
    # Reformat code_system
    transform(out, code_system = gsub("_CLASSIFICATION", "", out$code_system))
  )
}

enlist_datasets <- function(package, pattern) {
  # Preserve attached packages (this is tricky, hence on.exit and withr)
  packages <- sub("package:", "", grep("package", search(), value = TRUE))
  on.exit(purrr::walk(packages, library, character.only = TRUE), add = TRUE)

  with_package(package, {
    data <- grep(pattern, exported_data(package), value = TRUE)
    purrr::set_names(mget(data, inherits = TRUE), data)
  })
}

exported_data <- function(package) {
  utils::data(package = package)$results[, "Item"]
}

# Copy from withr::with_package to avoid dependency
with_package <- function(package,
                         code,
                         help,
                         pos = 2,
                         lib.loc = NULL,
                         character.only = TRUE,
                         logical.return = FALSE,
                         warn.conflicts = FALSE,
                         quietly = TRUE,
                         verbose = getOption("verbose")) {
  suppressPackageStartupMessages((get("library"))(
    package,
    help = help,
    pos = pos,
    lib.loc = lib.loc,
    character.only = character.only,
    logical.return = logical.return,
    warn.conflicts = warn.conflicts,
    quietly = quietly,
    verbose = verbose
  ))
  on.exit(detach(paste0("package:", package), character.only = TRUE))
  force(code)
}
