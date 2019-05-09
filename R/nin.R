#' @title Negated \code{in} operator
#'
#' @param x (`vector()`):
#'   Values that should not be in `y`.
#' @param y (`vector()`):
#'   Values to match against.
#' @usage x \%nin\% y
#' @rdname nin
#' @export
"%nin%" = function(x, y) {
  !match(x, y, nomatch = 0L)
}
