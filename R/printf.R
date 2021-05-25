#' @title Functions for Formatted Output and Conditions
#'
#' @description
#' `catf()`, `messagef()`, `warningf()` and `stopf()` are wrappers around [base::cat()],
#' [base::message()], [base::warning()] and [base::stop()], respectively.
#' The call is not included for warnings and errors.
#'
#' @param msg (`character(1)`)\cr
#'   Format string passed to [base::sprintf()].
#' @param file (`character(1)`)\cr
#'   Passed to [base::cat()].
#' @param ... (`any`)\cr
#'   Arguments passed down to [base::sprintf()].
#' @param wrap (`integer(1)` | `logical(1)`)\cr
#'   If set to a positive integer, [base::strwrap()] is used to wrap the string to the provided width.
#'   If set to `TRUE`, the width defaults to `0.9 * getOption("width")`.
#'   If set to `FALSE`, wrapping is disabled (default).
#'   If wrapping is enabled, all whitespace characters (`[[:space:]]`) are converted to spaces,
#'   and consecutive spaces are converted to a single space.
#'
#' @name printf
#' @examples
#' messagef("
#'   This is a rather long %s
#'   on multiple lines
#'   which will get wrapped.
#' ", "string", wrap = 15)
NULL

str_wrap = function(str, width = FALSE) {
  if (isFALSE(width)) {
    return(str)
  }

  if (isTRUE(width)) {
    width = as.integer(0.9 * getOption("width"))
  } else {
    assert_count(width)
  }

  paste0(strwrap(gsub("[[:space:]]+", " ", str), width = width), collapse = "\n")
}

#' @export
#' @rdname printf
catf = function(msg, ..., file = "", wrap = FALSE) {
  cat(paste0(str_wrap(sprintf(msg, ...), width = wrap), collapse = "\n"), "\n", sep = "", file = file)
}

#' @export
#' @rdname printf
messagef = function(msg, ..., wrap = FALSE) {
  message(str_wrap(sprintf(msg, ...), width = wrap))
}

#' @export
#' @rdname printf
warningf = function(msg, ..., wrap = FALSE) {
  warning(simpleWarning(str_wrap(sprintf(msg, ...), width = wrap), call = NULL))
}

#' @export
#' @rdname printf
stopf = function(msg, ..., wrap = FALSE) {
  stop(simpleError(str_wrap(sprintf(msg, ...), width = wrap), call = NULL))
}
