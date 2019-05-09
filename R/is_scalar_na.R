#' @title Check if an argument is a single scalar value
#'
#' @param x (any):
#'   Argument to check.
#' @return (`logical(1)`).
#' @export
is_scalar_na = function(x) {
  is.atomic(x) && length(x) == 1L && is.na(x)
}
