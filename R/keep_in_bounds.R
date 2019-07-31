#' @title Remove All Elements Out Of Bounds
#'
#' @description
#' Filters vector `x` to only keep elements which are in bounds `[lower, upper]`.
#' This is equivalent to the following, but tries to avoid unnecessary allocations:
#' ```
#'  x[!is.na(x) & x >= lower & x <= upper]
#' ```
#' Currently only works for integer `x`.
#'
#' @param x :: `integer()`\cr
#'   Vector to filter.
#' @param lower :: `integer(1)`\cr
#'   Lower bound.
#' @param upper :: `integer(1)`\cr
#'   Upper bound.
#' @return (integer()) with only values in `[lower, upper]`.
#' @useDynLib mlr3misc c_keep_in_bounds
#' @export
#' @examples
#' keep_in_bounds(sample(20), 5, 10)
keep_in_bounds = function(x, lower, upper) {
  assert_integer(x)
  lower = assert_int(lower, coerce = TRUE)
  upper = assert_int(upper, coerce = TRUE)
  .Call(c_keep_in_bounds, x, lower, upper, PACKAGE = "mlr3misc")
}
