#' @title Invoke a function call
#'
#' @description
#' An alternative interface for [do.call()], similar to the function in \pkg{purrr}.
#' It is best practice to pass all arguments named.
#'
#' @param .f ([function()]): Function to call.
#' @param .x ([list()]): List of function arguments passed to `.f`.
#' @param ... : Additional function arguments passed to `.f`.
#'  These arguments will be concatenated to the arguments provied via `.x`.
#' @export
#' @examples
#' invoke(mean, .x = list(x = 1:10))
#' invoke(mean, .x = list(1:10), na.rm = TRUE)
invoke = function(.f, .x = list(), ...) {
  envir = parent.frame()
  do.call(.f, c(as.list(.x), list(...)), envir = envir)
}
