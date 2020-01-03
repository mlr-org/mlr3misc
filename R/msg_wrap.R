#' @title Wrap Strings in Messages
#'
#' @description
#' Pretty printing for [message()] and [cat()].
#'
#' @param str :: `character()`\cr
#'   Vector of strings.
#' @param width :: `integer(1)`\cr
#'   Width of the output.
#'
#' @seealso [str_indent()]
#' @return (`character()`).
#' @name msg_wrap
#' @export
#' @examples
#' msg_wrap("This is a somewhat long message call with a line break
#'   in it. The output will be wrapped nicely in the console.
#'   Whitespace will be stripped.")
#'
#' cat_wrap("This is a somewhat long message call with a line break
#'   in it. The output will be wrapped nicely in the console.
#'   Whitespace will be stripped.")
msg_wrap = function(str, width = 0.9 * getOption("width")) {
  message(str_wrap(str, width = width))
}

#' @rdname msg_wrap
#' @export
cat_wrap = function(str, width = 0.9 * getOption("width")) {
  cat(str_wrap(str, width = width))
}

str_wrap = function(str, width = 0.9 * getOption("width")) {
  paste0(strwrap(gsub("[[:space:]]+", " ", str), width = width),
    collapse = "\n")
}
