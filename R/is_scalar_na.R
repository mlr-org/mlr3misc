#' @title Check for a Single Scalar Value
#'
#' @param x (`any`)\cr
#'   Argument to check.
#' @return (`logical(1)`).
#' @export
is_scalar_na = function(x) {
  is.atomic(x) && length(x) == 1L && is.na(x)
}
