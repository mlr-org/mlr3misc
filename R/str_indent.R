#' @param initial (`character(1)`):
#'   Initial string, passed to [strwrap()].
#' @param width (`integer(1)`):
#'   Width, passed to [strwrap()].
#' @param ... (any): Additional parameters passed to [str_collapse()] to
#'   collapse `str`.
#' @rdname string_helpers
#' @export
str_indent = function(initial, str, width = 0.9 * getOption("width"), ...) {
  if (length(str) == 0L)
    str = "-"
  strwrap(str_collapse(str, ...), initial = paste0(initial, " "), exdent = 2L, width = width)
}
