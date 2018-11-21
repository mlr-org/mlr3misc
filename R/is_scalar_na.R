#' @title Check if an argument is a single scalar value
#'
#' @param x \[any\]:\cr
#'  Argument to check.
#' @return \[logical(1)\].
#' @export
is_scalar_na = function(x) {
  is.vector(x) && length(x) == 1L && is.na(x)
}
