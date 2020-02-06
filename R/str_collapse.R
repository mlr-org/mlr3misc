#' @title Collapse Strings
#'
#' @description
#' Collapse multiple strings into a single string.
#'
#' @param str (`character()`)\cr
#'   Vector of strings.
#' @param sep (`character(1)`)\cr
#'   String used to collapse the elements of `x`.
#' @param quote (`character(1)`)\cr
#'   Quotes to use around each element of `x`.
#' @param n (`integer(1)`)\cr
#'   Number of elements to keep from `x`. See [utils::head()].
#' @param ellipsis (`character(1)`)\cr
#'   If the string has to be shortened, this is signaled by appending `ellipsis` to `str`. Default is `" [...]"`.
#'
#' @return (`character(1)`).
#'
#' @export
#' @examples
#' str_collapse(letters, quote = "'", n = 5)
str_collapse = function(str, sep = ", ", quote = "", n = Inf, ellipsis = "[...]") {
  formatted = head(str, n)
  if (nzchar(quote)) {
    formatted = paste0(quote, formatted, quote)
  }
  if (length(str) > n) {
    formatted = c(formatted, ellipsis)
  }
  paste0(formatted, collapse = sep)
}
