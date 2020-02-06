#' @title Truncate Strings
#'
#' @description
#' `str_trunc()` truncates a string to a given width.
#'
#' @param str (`character()`)\cr
#'   Vector of strings.
#' @param width (`integer(1)`)\cr
#'   Width of the output.
#' @param ellipsis (`character(1)`)\cr
#'   If the string has to be shortened, this is signaled by appending `ellipsis` to `str`. Default is `"[...]"`.
#'
#' @return (`character()`).
#' @export
#' @examples
#' str_trunc("This is a quite long string", 20)
str_trunc = function(str, width = 0.9 * getOption("width"), ellipsis = "[...]") {
  str = as.character(str)
  ellipsis = assert_string(ellipsis)
  nc_ellipsis = nchar(ellipsis)
  width = assert_int(width, lower = nc_ellipsis)

  ind = (!is.na(str) & nchar(str) > width)
  replace(str, ind, paste0(substr(str[ind], 1L, width - nc_ellipsis), ellipsis))
}
