#' @title Indent Strings
#'
#' @description
#' Formats a text block for printing.
#'
#' @param initial :: `character(1)`\cr
#'   Initial string, passed to [strwrap()].
#' @param str :: `character()`\cr
#'   Vector of strings.
#' @param width :: `integer(1)`\cr
#'   Width of the output.
#' @param exdent :: `integer(1)`\cr
#'   Indentation of subsequent lines in paragraph.
#' @param ... :: `any`\cr
#'   Additional parameters passed to [str_collapse()].
#'
#' @return (`character()`).
#' @export
#' @examples
#' cat(str_indent("Letters:", str_collapse(letters), width = 25), sep = "\n")
str_indent = function(initial, str, width = 0.9 * getOption("width"), exdent = 2L, ...) {
  if (length(str) == 0L) {
    str = "-"
  }
  strwrap(str_collapse(str, ...), initial = paste0(initial, " "), exdent = exdent, width = width)
}
