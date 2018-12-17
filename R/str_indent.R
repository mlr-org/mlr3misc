#' @param initial (`character(1)`):
#'   Initial string, passed to [strwrap()].
#' @param width (`integer(1)`):
#'   Width, passed to [strwrap()].
#' @rdname string_helpers
#' @export
str_indent = function(initial, str, width = 0.9 * getOption("width")) {
  if (length(str) == 0L)
    str = "-"
  paste0(strwrap(str, initial = paste0(initial, " "), exdent = 2L, width = width),
    collapse = "\n")
}
