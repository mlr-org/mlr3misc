#' @title Index of the Minimum/Maximum Value, with ties correction
#'
#'@description
#' Works similar to [base::which.min()]/[base::which.max()], but corrects for ties.
#' Missing values are set to `Inf` for `which_min` and to `-Inf` for `which_max()`.
#'
#' @param x :: `numeric()`\cr
#'    Numeric vector.
#' @param ties_method :: `character(1)`\cr
#'   Handling of ties. One of "first", "last" or "random" (default) to return the first index,
#'   the last index, or a random index of the minimum/maximum values.
#'   Passed down to [base::max.col()].
#'
#' @return (`integer()`): Index of the minimum/maximum value.
#'   Returns an empty integer vector for empty input vectors and vectors with no non-missing values.
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
which_min = function(x, ties_method = "random") {
  which_max(-x, ties_method)
}

#' @rdname which_min
#' @export
which_max = function(x, ties_method = "random") {
  assert_numeric(x)
  if (length(x) == 0L) {
    return(integer())
  }
  x[is.na(x)] = -Inf
  max.col(t(x), ties.method = ties_method)
}
