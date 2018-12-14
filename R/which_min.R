#' @title Get the index of the minimum/maximum value, with ties correction
#'
#' Works similar to [base::which.min()]/[base::which.max()], but corrects for ties.
#'
#' @param x (`numeric()`): Numeric vector.
#' @param ties.method (`character(1)`):
#'  Handling of ties. One of "first", "last" or "random" to return the first index,
#'  the last index, or a random index of the minimum/maximum values.
#' @return (`integer(1)`): index of the minimum/maximum value.
#'  Returns (`integer(0)`) for empty vectors and vectors with no non-missing values.
#' @export
#' @examples
#' x = c(2, 3, 1, 3, 5, 1, 1)
#' which_min(x, ties.method = "first")
#' which_min(x, ties.method = "last")
#' which_min(x, ties.method = "random")
#'
#' which_max(x)
which_min = function(x, ties.method = "random") {
  assert_numeric(x)
  which_equal(x, x[which.min(x)], ties.method)
}

#' @rdname which_min
#' @export
which_max = function(x, ties.method = "random") {
  assert_numeric(x)
  i = which.max(x)
  which_equal(x, x[which.max(x)], ties.method)
}

which_equal = function(x, y, ties.method = "random") {
  if (length(y) == 0L)
    return(integer(0L))
  i = which(x == y)
  switch(ties.method,
    random = shuffle(i, 1L),
    first = i[1L],
    last = i[length(i)],
    stop("Invalid ties method")
  )
}
