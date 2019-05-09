#' @title Output and condition helpers for mlr3
#'
#' @description
#' `catf()`, `messagef()`, `warningf()` and `stopf()` are wrappers around [base::cat()],
#' [base::message()], [base::warning()] and [base::stop()], respectively.
#'
#' @param msg (`character(1)):
#'   Format string passed to [base::sprintf()].
#' @param file (`character(1)):
#'   Passed to [base::cat()].
#' @param ... (any):
#'   Arguments passed down to [base::sprintf()].
#' @name printf
NULL

#' @export
#' @rdname printf
catf = function(msg, ..., file = "") {
  cat(paste0(sprintf(msg, ...), collapse = "\n"), "\n", sep = "", file = file)
}

#' @export
#' @rdname printf
messagef = function(msg, ...) {
  message(sprintf(msg, ...))
}

#' @export
#' @rdname printf
warningf = function(msg, ...) {
  warning(simpleWarning(sprintf(msg, ...), call = NULL))
}

#' @export
#' @rdname printf
stopf = function(msg, ...) {
  stop(simpleError(sprintf(msg, ...), call = NULL))
}
