#' @title Extract ids from a List of Objects
#'
#' @description
#' None.
#'
#' @param xs (`list()`)\cr
#'   Every element must have a slot 'id'.
#'
#' @return (`character()`).
#' @export
#' @examples
#' xs = list(a = list(id = "foo", a = 1), bar = list(id = "bar", a = 2))
#' ids(xs)
ids = function(xs) {
  vapply(xs, "[[", "id", FUN.VALUE = NA_character_, USE.NAMES = FALSE)
}
