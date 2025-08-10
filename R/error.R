#' @title Configuration Error
#' @description
#' Configuration error.
#' Calls [`stopf`] with class `"mlr3ConfigError"`.
#' @param msg (`character(1)`)\cr
#'   Error message.
#' @param ... (any)\cr
#'   Passed to [`stopf`].
#' @param class (`character`)\cr
#'   Additional class(es).
#' @export
config_error <- function(msg, ..., class = NULL) {
  class <- c(class, "mlr3ConfigError")
  stopf(msg, ..., class = class)
}
