#' @title Create a named list, possibly initialized with a certain element.
#'
#' @param nn (`character()`):
#'   Names of elements.
#' @param init (valid R expression):
#'   All list elements are initialized to this value.
#' @return (`list()`].
#' @export
#' @examples
#' named_list(c("a", "b"))
#' named_list(c("a", "b"), init = 1)
named_list = function(nn = character(0L), init = NULL) {
  assert_character(nn, any.missing = FALSE)
  x = vector("list", length(nn))
  if (!is.null(init)) {
    x[] = list(init)
  }
  names(x) = nn
  return(x)
}
