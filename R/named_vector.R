#' @title Create a Named Vector
#'
#' @param nn :: `character()`\cr
#'   Names of new vector
#' @param init :: `atomic`\cr
#'   All vector elements are initialized to this value.
#' @return (named `vector()`).
#' @export
#' @examples
#' named_vector(c("a", "b"), NA)
named_vector = function(nn = character(0L), init = NA) {
  assert_character(nn, any.missing = FALSE)
  assert_atomic(init, len = 1L)
  set_names(rep(init, len = length(nn)), nn)
}
