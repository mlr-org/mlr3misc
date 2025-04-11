#' @title Functions for Formatted Output and Conditions
#'
#' @description
#' `catf()`, `messagef()`, `warningf()` and `stopf()` are wrappers around [base::cat()],
#' [base::message()], [base::warning()] and [base::stop()], respectively.
#'
#' @section Errors and Warnings:
#' Errors and warnings get the classes `mlr3{error, warning}` and also inherit from
#' `simple{Error, Warning}`.
#' It is possible to give errors and warnings their own class via the `class` argument.
#' Doing this, allows to suppress selective conditions via calling handlers, see e.g.
#' [`globalCallingHandlers`].
#'
#' When a function throws such a condition that the user might want to disable,
#' a section *Errors and Warnings* should be included in the function documention,
#' describing the condition and its class.
#'
#' @details
#' For leanified R6 classes, the call included in the condition is the method call
#' and not the call into the leanified method.
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
#' @param class (`character()`)\cr
#'   Class of the condition (for errors and warnings).
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
messagef = function(msg, ..., wrap = FALSE, class = NULL) {
  message(str_wrap(sprintf(msg, ...), width = wrap))
}

#' @export
#' @rdname printf
warningf = function(msg, ..., wrap = FALSE, class = NULL) {
  class <- c(class, c("mlr3warning", "simpleWarning", "warning", "condition"))
  message = str_wrap(sprintf(msg, ...), width = wrap)
  call = sys_call_unleanified()
  warning(structure(list(message = as.character(message), call = call), class = class))
}

#' @export
#' @rdname printf
stopf = function(msg, ..., wrap = FALSE, class = NULL) {
  class <- c(class, c("mlr3error", "simpleError", "error", "condition"))
  message = str_wrap(sprintf(msg, ...), width = wrap)
  call = sys_call_unleanified()
  stop(structure(list(message = as.character(message), call = call), class = class))
}

sys_call_unleanified = function(which = -2) {
  # when we throw an error in learner$predict(task), we want don't want to see the call
  # .__Learner__predict(self = self, ...), but learner$predict(task)
  call = sys.call(which)
  if (!is.null(call) && grepl("^\\.__(.*)__", as.character(call[1]))) {
    return(sys.call(which - 1))
  }
  return(call)
}
