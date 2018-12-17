#' @param n (`integer(1)`):\cr
#'   Number of elements to keep from `x`. See [utils::head()].
#' @param sep (`character(1)`):\cr
#'   String used to collapse the elements of `x`.
#' @param quote (`character(1)`):\cr
#'   Quotes to use around each element of `x`.
#' @rdname string_helpers
#' @export
str_collapse = function(str, sep = ", ", quote = "", n = Inf, ellipsis = "[...]") {
  formatted = head(str, n)
  if (nzchar(quote))
    formatted = paste0(quote, formatted, quote)
  if (length(str) > n)
    formatted = c(formatted, ellipsis)
  paste0(formatted, collapse = collapse)
}
