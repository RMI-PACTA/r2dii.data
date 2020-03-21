#' A loanbook dataset for demonstration
#'
#' @description
#' Financial portfolios, such as corporate debt loanbooks, are analyzed using
#' the 'PACTA' tool (<https://2degrees-investing.org/resource/pacta/>). Real
#' financial data is private.
#' @template info_demo-datasets
#'
#' @family demo datasets
#' @seealso [data_dictionary]
#'
#' @format
#' `loanbook_demo` is a [data.frame] with columns:
#' * `fi_type` (character): Financial instrument name or asset class.
#' * `flag_project_finance_loan` (character): Project finance flag denoting
#' whether a loan is given out to a particular asset or not.
#' * `id_direct_loantaker` (character): Borrower identifier unique to each
#' borrower/sector combination in loanbook.
#' * `id_intermediate_parent_n` (character): Optional input: id of the n-th
#' intermediate parent company within the company structure that can be used for
#' more granular mapping than the ultimate parent. Smaller values of n are
#' closer to the direct_loantaker.
#' * `id_loan` (character): Unique loan identifier.
#' * `id_ultimate_parent` (character): Ultimate parent identifier unique to each
#' ultimate parent/sector combination.
#' * `isin_direct_loantaker` (logical): Optional input: providing the isin
#' identifier of the direct loan taker to improve the matching coverage.
#' * `lei_direct_loantaker` (logical): Optional input: providing the lei (legal
#' entity identifier) of the direct loan taker to improve the matching coverage.
#' * `loan_size_credit_limit` (double): Total credit limit or exposure at
#' default.
#' * `loan_size_credit_limit_currency` (character): Currency corresponding to
#' credit limit.
#' * `loan_size_outstanding` (double): Amount drawn by borrower from total
#' credit limit.
#' * `loan_size_outstanding_currency` (character): Currency corresponding to
#' outstandings.
#' * `name_direct_loantaker` (character): Name of the company directly taking
#' the loan.
#' * `name_intermediate_parent_n` (character): Optional input: name of
#' intermediate parent company within the company structure that can be used for
#' more granular mapping than the ultimate parent. Smaller values of n are
#' closer to the direct_loantaker.
#' * `name_project` (logical): Required input for loans with the
#' flag_project_finance_loan = TRUE: Name of the project being financed.
#' * `name_ultimate_parent` (character): Name of the ultimate parent company to
#' which the borrower belongs. Can be the same as borrower.
#' * `sector_classification_direct_loantaker` (double): Sector classification
#' code of the direct loantaker.
#' * `sector_classification_input_type` (character): Flag identifying if the
#' sector classification code or character description is used.
#' * `sector_classification_system` (character): Name of the sector
#' classification standard being used.
#'
#' @examples
#' head(loanbook_demo)
"loanbook_demo"
