#' @title Convert to Factor
#'
#' @description
#' Converts a vector to a [factor()] and ensures that levels are
#' in the order of the provided levels.
#'
#' @param x (atomic `vector()`)\cr
#'   Vector to convert to factor.
#' @param levels (`character()`)\cr
#'   Levels of the new factor.
#' @param ordered (`logical(1)`)\cr
#'   If `TRUE`, create an ordered factor.
#' @return (`factor()`).
#' @export
#' @examples
#' x = factor(c("a", "b"))
#' y = factor(c("a", "b"), levels = c("b", "a"))
#'
#' # x with the level order of y
#' as_factor(x, levels(y))
#'
#' # y with the level order of x
#' as_factor(y, levels(x))
as_factor = function(x, levels, ordered = is.ordered(x)) {
  assert_flag(ordered)
  levels = as.character(levels)
  if (is.factor(x)) {
    if (!identical(levels(x), levels) || ordered != is.ordered(x)) {
      x = factor(x, levels = levels, ordered = ordered)
    }
  } else {
    x = factor(as.character(x), levels = levels, ordered = ordered)
  }
  x
}
