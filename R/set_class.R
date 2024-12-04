#' @title Set the Class
#'
#' @description
#' Simple wrapper for `class(x) = classes`.
#'
#' @param x (`any`).
#' @param classes (`character(1)`)\cr
#'   Vector of new class names.
#'
#' @return Object `x`, with updated class attribute.
#' @export
#' @examples
#' set_class(list(), c("foo1", "foo2"))
set_class = function(x, classes) {
  class(x) = classes
  x
}
