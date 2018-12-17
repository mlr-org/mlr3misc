#' @title Miscellaneous string helper functions
#'
#' @description
#' * `str_trunc()` truncates a string to a given width.
#' * `str_collapse()` returns the first elements of a character vector.
#' * `str_paragraph()` formats the text in `str` with [strwrap()].
#'
#' @param str (`character()`): Vector of strings.
#' @param ellipsis (`character(1)`): If the string has to be shortened, this is signaled by appending `ellipsis` to `str`. Default is `" [...]"`.
#' @return (`character(1)`).
#' @name string_helpers
#' @examples
#' str_trunc("This is a quite long string", 20)
#' str_collapse(letters, quote = "'", n = 5)
#' message(str_indent("Some letters:", str_collapse(letters), width = 25))
NULL

#' @rdname string_helpers
#' @export
str_trunc = function(str, width = 0.9 * getOption("width"), ellipsis = "[...]") {
  str = as.character(str)
  ellipsis = assert_string(ellipsis)
  nc_ellipsis = nchar(ellipsis)
  width = assert_int(width, lower = nc_ellipsis)

  ind = (!is.na(str) & nchar(str) > width)
  replace(str, ind, paste0(substr(str[ind], 1L, width - nc_ellipsis), ellipsis))
}
