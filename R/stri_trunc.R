#' @title Miscellaneous string helper functions
#'
#' @description
#' * `stri_trunc()` truncates a string to a given width.
#' * `stri_head()` returns the first elements of a character vector.
#'
#' @param str \[`character()`\]:\cr
#'   Vector of strings.
#' @param ellipsis \[`character(1)`\]:\cr
#'   If the string has to be shortened, this is signaled by appending `ellipsis` to `str`. Default is `" [...]"`.
#' @return \[`character(1)`\].
#' @name string_helpers
#' @examples
#' stri_trunc("This is a quite long string", 20)
NULL

#' @param width \[`integer(1)`\]:\cr
#'   Absolute length the string should be truncated to, including `ellipsis`.
#'   Note that you cannot truncate to a shorter length than `ellipsis`.
#' @rdname string_helpers
#' @export
stri_trunc = function(str, width, ellipsis = "[...]") {
  str = as.character(str)
  ellipsis = assert_string(ellipsis)
  n_ellipsis = nchar(ellipsis)
  width = assert_int(width, lower = n_ellipsis, coerce = TRUE)

  ind = (!is.na(str) & nchar(str) > width)
  replace(str, ind, paste0(substr(str[ind], 1L, width - n_ellipsis), ellipsis))
}
