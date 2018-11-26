#' @title Truncate a string to a given length.
#'
#' @param str \[`character()`\]:\cr
#'   Vector of strings.
#' @param width \[`integer(1)`\]:\cr
#'   Absolute length the string should be truncated to, including `ellipsis`.
#'   Note that you cannot truncate to a shorter length than `ellipsis`.
#' @param tail \[`character(1)`\]:\cr
#'   If the string has to be shortened at least 1 character, the last characters
#'   will be `ellipsis`. Default is `" [...]"`.
#' @return \[`character(1)`\].
#' @export
#' @examples
#' stri_trunc("This is a quite long string", 20)
stri_trunc = function(str, width, ellipsis = "[...]") {
  str = as.character(str)
  n_ellipsis = nchar(ellipsis)
  ellipsis = assert_string(ellipsis)
  width = assert_int(width, lower = n_ellipsis, coerce = TRUE)

  ind = (!is.na(str) & nchar(str) > width)
  replace(str, ind, paste0(substr(str[ind], 1L, width - n_ellipsis), ellipsis))
}
