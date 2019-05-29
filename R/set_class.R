#' @title Set the Class
#'
#' @description
#' Simple wrapper for `class(x) = classes`.
#'
#' @param x (any):
#'   Your object.
#' @param classes (`character(1)`):
#'   Vector of new classes.
#'
#' @return Changed object \code{x}.
#' @export
#' @examples
#' set_class(list(), c("foo1", "foo2"))
set_class = function(x, classes) {
  class(x) = classes
  x
}
