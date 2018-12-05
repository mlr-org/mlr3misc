#' @title A wrapper for \code{class(x) = classes}.
#'
#' @param x : Your object.
#' @param classes (\code{character(1)}): New classes.
#' @return Changed object \code{x}.
#' @export
#' @examples
#' set_class(list(), c("foo1", "foo2"))
set_class = function(x, classes) {
  class(x) = classes
  x
}
