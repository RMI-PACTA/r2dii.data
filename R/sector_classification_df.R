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
  out <- enlist_datasets("r2dii.data", pattern = "_classification$") %>%
    purrr::imap(~ transform(.x, code_system = toupper(.y))) %>%
    purrr::map(~ .x[c("sector", "borderline", "code", "code_system")]) %>%
    # Coerce every column to character for more robust reduce() and join()
    purrr::map(~ purrr::modify(.x, as.character)) %>%
    # Collapse the list of dataframes to a single, row-bind dataframe
    purrr::reduce(rbind) %>%
    purrr::modify_at("borderline", as.logical) %>%
    # Avoid duplicates
    unique()

  out %>%
    # Reformat code_system
    transform(code_system = gsub("_CLASSIFICATION", "", out$code_system)) %>%
    tibble::as_tibble()
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
