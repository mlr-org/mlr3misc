#' @title Invoke a function call
#'
#' @description
#' An alternative interface for [do.call()], similar to the deprecated function in \pkg{purrr}.
#' This function tries hard to not evaluate the passed arguments too eagerly which is
#' important when working with large R objects.
#'
#' It is recommended to pass all arguments named to not rely on on positional argument matching.
#'
#'
#' @param .f ([function()]): Function to call.
#' @param ... : Additional function arguments passed to `.f`.
#' @param .args ([list()]): List of function arguments passed to `.f`.
#'  These arguments will be concatenated to the arguments provided via `...`.
#' @export
#' @examples
#' invoke(mean, .args = list(x = 1:10))
#' invoke(mean, na.rm = TRUE, .args = list(1:10))
invoke = function(.f, ..., .args = list()) {
  call = match.call(expand.dots = FALSE)
  expr = as.call(c(list(call[[2L]]), call$..., .args))
  eval.parent(expr, n = 1L)
}
