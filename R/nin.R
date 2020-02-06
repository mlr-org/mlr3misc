#' @title Negated in-operator
#'
#' @description
#' This operator is equivalent to `!(x %in% y)`.
#'
#' @param x (`vector()`)\cr
#'   Values that should not be in `y`.
#' @param y (`vector()`)\cr
#'   Values to match against.
#' @usage x \%nin\% y
#' @rdname nin
#' @export
"%nin%" = function(x, y) {
  !match(x, y, nomatch = 0L)
}
