#' @title Create a Named Vector
#'
#' @description
#' Creates a simple atomic vector with `init` as values.
#'
#' @param nn (`character()`)\cr
#'   Names of new vector
#' @param init (`atomic`)\cr
#'   All vector elements are initialized to this value.
#' @return (named `vector()`).
#' @export
#' @examples
#' named_vector(c("a", "b"), NA)
#' named_vector(character())
named_vector = function(nn = character(0L), init = NA) {
  assert_character(nn, any.missing = FALSE)
  assert_atomic(init, len = 1L)
  res = rep(init, length.out = length(nn))
  names(res) = nn
  res
}
