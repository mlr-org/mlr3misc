#' @title Reorder Vector According to Second Vector
#'
#' @description
#' Reorders `x` to have the same order as `y`.
#' Duplicated elements will be removed.
#'
#' @param x (`vector())`.
#' @param y (`vector()`).
#' @param na_last (`logical(1)`)\cr
#'   What to do with values in `x` which are not in `y`?
#'   * `NA`: Extra values are removed.
#'   * `FALSE`: Extra values are moved to the beginning of the new vector.
#'   * `TRUE`: Extra values are moved to the end of the new vector.
#' @return (`vector()`) `x` with reordered values.
#' @export
#' @examples
#' # x subset of y
#' x = c("b", "a", "c", "d")
#' y = letters
#' x[reorder_vector(x, y)]
#'
#' # y subset of x
#' y = letters[1:3]
#' x[reorder_vector(x, y)]
#' x[reorder_vector(x, y, na_last = TRUE)]
#' x[reorder_vector(x, y, na_last = FALSE)]
reorder_vector = function(x, y, na_last = NA) {
  assert_flag(na_last, na.ok = TRUE)
  order(match(x, y), na.last = na_last)
}
