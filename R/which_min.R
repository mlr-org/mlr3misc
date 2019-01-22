#' @title Get the index of the minimum/maximum value, with ties correction
#'
#' Works similar to [base::which.min()]/[base::which.max()], but corrects for ties.
#'
#' @param x (`numeric()`): Numeric vector.
#' @param ties_method (`character(1)`):
#'  Handling of ties. One of "first", "last" or "random" to return the first index,
#'  the last index, or a random index of the minimum/maximum values.
#'  Passed down to [base::max.col()].
#' @param na_rm (`logical(1)`):
#'  If `TRUE`, ignore missing values.
#' @return (`integer(1)`): index of the minimum/maximum value.
#'  Returns (`integer(0)`) for empty vectors and vectors with no non-missing values.
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
which_min = function(x, ties_method = "random", na_rm = TRUE) {
  assert_vector(x, strict = TRUE)
  if (isTRUE(na_rm))
    x = x[!is.na(x)]
  if (length(x) == 0L)
    return(integer())
  max.col(t(-x), ties.method = ties_method)
}

#' @rdname which_min
#' @export
which_max = function(x, ties_method = "random", na_rm = TRUE) {
  assert_vector(x, strict = TRUE)
  if (isTRUE(na_rm))
    x = x[!is.na(x)]
  if (length(x) == 0L)
    return(integer())
  max.col(t(x), ties.method = ties_method)
}
