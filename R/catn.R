#' @title Function for Formatted Output
#'
#' @description
#' Wrapper around [base::cat()] with a line break.
#' Elements are converted to character and concatenate with [base::paste0()].
#' If a vector is passed, elements are collapsed with line breaks.
#'
#' @param ... (`any`)\cr
#'   Arguments passed down to [base::paste0()].
#' @param file (`character(1)`)\cr
#'   Passed to [base::cat()].
#'
#' @export
#' @examples
#' catn(c("Line 1", "Line 2"))
catn = function(..., file = "") {
  cat(paste0(..., collapse = "\n"), "\n", sep = "", file = file)
}
