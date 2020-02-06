#' @title Compute The Mode
#'
#' @description
#' Computes the mode (most frequent value) of an atomic vector.
#'
#' @param x (`vector()`).
#' @param ties_method (`character(1)`)\cr
#'   Handling of ties. One of "first", "last" or "random" to return the first tied value,
#'  the last tied value, or a randomly selected tied value, respectively.
#' @param na_rm (`logical(1)`)\cr
#'   If `TRUE`, remove missing values prior to computing the mode.
#' @return (`vector(1)`): mode value.
#' @export
#' @examples
#' compute_mode(c(1, 1, 1, 2, 2, 2, 3))
#' compute_mode(c(1, 1, 1, 2, 2, 2, 3), ties_method = "last")
#' compute_mode(c(1, 1, 1, 2, 2, 2, 3), ties_method = "random")
compute_mode = function(x, ties_method = "random", na_rm = TRUE) {
  assert_atomic_vector(x)
  if (na_rm) {
    x = x[!is.na(x)]
  }
  as.data.table(x)[, .N, by = list(x)][which_max(get("N"), ties_method = ties_method)]$x
}
