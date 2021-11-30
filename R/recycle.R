#' @title Recycle List of Vectors to Common Length
#'
#' @description
#' Repeats all vectors of a list `.x` to the length of the longest vector
#' using [rep()] with argument `length.out`.
#' This operation will only work
#' if the length of the longest vectors is an integer multiple of all shorter
#' vectors, and will throw an exception otherwise.
#'
#' @param .x (`list()`).
#' @return (`list()`) with vectors of same size.
#' @export
#' @examples
#' recycle_vectors(list(a = 1:3, b = 2))
recycle_vectors = function(.x) {
  assert_list(.x, min.len = 1L)

  n = lengths(.x)
  n_max = max(n)

  if (n_max == 0L) {
    return(.x)
  }

  if (any(n == 0L) || any(n_max %% n > 0L)) {
    stop("Cannot recycle vectors to common length")
  }

  ii = which(n != n_max)
  if (length(ii)) {
    .x[ii] = lapply(.x[ii], rep, length.out = n_max)
  }

  .x
}
