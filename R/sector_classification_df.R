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
#' data_dictionary() %>%
#'   dplyr::filter(
#'     grepl("_classification", dataset),
#'     column %in% c("sector", "borderline", "code", "code_system")
#'  ) %>%
#'  dplyr::arrange(column)
sector_classification_df <- function() {
  enlist_datasets("r2dii.dataraw", pattern = "_classification$") %>%
    purrr::imap(~ dplyr::mutate(.x, code_system = toupper(.y))) %>%
    purrr::map(
      dplyr::select,
      .data$sector, .data$borderline, .data$code, .data$code_system
    ) %>%
    # Coerce every column to character for more robust reduce() and join()
    purrr::map(~ purrr::modify(.x, as.character)) %>%
    # Collapse the list of dataframes to a single, row-bind dataframe
    purrr::reduce(dplyr::bind_rows) %>%
    purrr::modify_at("borderline", as.logical) %>%
    # Avoid duplicates
    unique() %>%
    # Reformat code_system
    dplyr::mutate(code_system = gsub("_CLASSIFICATION", "", .data$code_system))
}

enlist_datasets <- function(package, pattern) {
  # Preserve attached packages
  packages <- sub("package:", "", grep("package", search(), value = TRUE))
  on.exit(purrr::walk(packages, library, character.only = TRUE), add = TRUE)

  withr::with_package(package, {
      data <- grep(pattern, exported_data(package), value = TRUE)
      purrr::set_names(mget(data, inherits = TRUE), data)
    }
  )
}

exported_data <- function(package) {
  utils::data(package = package)$results[, "Item"]
}
