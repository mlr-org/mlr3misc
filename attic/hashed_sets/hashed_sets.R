#' @title Hashing Set Functions
#'
#' @name hashed_sets
#' @description
#' The following attributes are attached to atomic input vectors to speed up set operations:
#'
#' * `.match.hash` is an external pointer to a hash table constructed by [fastmatch::fmatch()].
#' * `.unique` is a single logical value which stores that the vector is know to only have unique values.
#'
#' The following functions take advantage of the cached attributes:
#'
#' * `set_unique_flag()` sets the `.unique` attribute by reference.
#' * `wunique()` is a wrapper around [base::unique()] which either skips computation of unique values
#'   if the `.unique` flag is found, or calculates unique values and sets the flag.
#' * `set_union()`, `set_equal()`, `set_intersect()` and `set_diff()` are the hashed replacement
#'   functions for [union()], [setequal()], [intersect()] and [setdiff()].
#'
#' @param x (`vector()`).
#' @param y (`vector()`).
#' @param is_unique (`logical(1)`). Skips calculation of unique values if set to `TRUE`.
#'   Used to pass external information about uniqueness down to `wunique()`.
#'
#' @export
wunique = function(x, is_unique = FALSE) {
  if (is.null(attr(x, ".unique"))) {
    if (!isTRUE(is_unique))
      x = unique(x)
    set_unique_flag(x)
  }
  x
}

#' @rdname hashed_sets
#' @useDynLib mlr3misc C_set_unique_flag
#' @export
set_unique_flag = function(x) {
  .Call(C_set_unique_flag, x)
}

#' @rdname hashed_sets
#' @export
set_union = function(x, y) {
  wunique(c(x, y))
}

#' @rdname hashed_sets
#' @export
set_equal = function(x, y) {
  !(anyMissing(fmatch(x, y)) || anyMissing(fmatch(y, x)))
}

#' @rdname hashed_sets
#' @export
set_intersect = function(x, y) {
  is_hashed = function(x) !is.null(attr(x, ".match.hash"))

  if (is_hashed(y) || !is_hashed(x))
    wunique(y[fmatch(x, y, 0L)], attr(x, ".unique"))
  else
    wunique(x[fmatch(y, x, 0L)], attr(y, ".unique"))
}

#' @rdname hashed_sets
#' @export
set_diff = function(x, y) {
  if (length(x) == 0L && length(y) == 0L)
    return(x)
  wunique(x[fmatch(x, y, 0L) == 0L], attr(x, ".unique"))
}
