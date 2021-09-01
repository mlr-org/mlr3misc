#' @title Capitalize the First Letter of Strings
#'
#' @description
#' Takes a character vector and changes the first letter of each element to
#' uppercase.
#'
#' @param str (`character()`).
#'
#' @return Character vector, same length as `str`.
#' @export
#' @examples
#' capitalize("foo bar")
capitalize = function(str) {
  substr(str, 1L, 1L) = toupper(substr(str, 1L, 1L))
  str
}
