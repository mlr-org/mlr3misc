#' @title Index of the Minimum/Maximum Value, with Correction for Ties
#'
#' @description
#' Works similar to [base::which.min()]/[base::which.max()], but corrects for ties.
#' Missing values are treated as `Inf` for `which_min` and as `-Inf` for `which_max()`.
#'
#' @param x (`numeric()`)\cr
#'   Numeric vector.
#' @param ties_method (`character(1)`)\cr
#'   Handling of ties. One of "first", "last" or "random" (default) to return the first index,
#'   the last index, or a random index of the minimum/maximum values.
#' @param na_rm (`logical(1)`)\cr
#'   Remove NAs before computation?
#'
#' @return (`integer()`): Index of the minimum/maximum value.
#'   Returns an empty integer vector for empty input vectors and vectors with no non-missing values
#'   (if `na_rm` is `TRUE`).
#'   Returns `NA` if `na_rm` is `FALSE` and at least one `NA` is found in `x`.
#' @export
#' @examples
#' x = c(2, 3, 1, 3, 5, 1, 1)
#' which_min(x, ties_method = "first")
#' which_min(x, ties_method = "last")
#' which_min(x, ties_method = "random")
#'
#' which_max(x)
#' which_max(integer(0))
#' which_max(NA)
#' which_max(c(NA, 1))
which_min = function(x, ties_method = "random", na_rm = FALSE) {
  x = if (is.logical(x)) !x else -x
  which_max(x, ties_method, na_rm)
}

#' @rdname which_min
#' @useDynLib mlr3misc c_which_max
#' @export
which_max = function(x, ties_method = "random", na_rm = FALSE) {
  assert_flag(na_rm)
  .Call(c_which_max, x, ties_method, na_rm, PACKAGE = "mlr3misc")
}
