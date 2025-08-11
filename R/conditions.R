#' @title Error Classes
#' @name mlr_conditions
#' @description
#' Error classes for mlr3.
#' Currently supported classes:
#'
#' @param msg (`character(1)`)\cr
#'   Error message.
#' @param ... (any)\cr
#'   Passed to [`sprintf()`].
#' @param class (`character`)\cr
#'   Additional class(es).
#' @param silent (`logical(1)`)\cr
#'   If `TRUE`, the condition object is returned.
#' @export
error_config = function(msg, ..., class = NULL, silent = FALSE) {
  condition <- mlr3_error(msg, ..., class = "mlr3ErrorConfig")
  if (silent) {
    return(condition)
  }
  stop_with_class(condition)
}

#' @rdname mlr_conditions
#' @export
error_timeout = function(silent = FALSE) {
  condition <- mlr3_error("reached elapsed time limit", class = "mlr3ErrorTimeout")
  if (silent) {
    return(condition)
  }
  stop_with_class(condition)
}

#' @rdname mlr_conditions
#' @export
mlr3_error = function(msg, ..., class = NULL) {
  errorCondition(sprintf(msg, ...), class = c(class, "mlr3Error"))
}

#' @rdname mlr_conditions
#' @export
mlr3_warning = function(msg, ..., class = NULL) {
  msg = sprintf(msg, ...)
  warningCondition(msg, class = c(class, "mlr3Warning"))
}

#' @rdname mlr_conditions
#' @export
warning_config = function(msg, ..., class = NULL, silent = FALSE) {
  condition <- mlr3_warning(msg, ..., class = "mlr3WarningConfig")
  if (silent) {
    return(condition)
  }
  warn_with_class(condition)
}

#' @title Throw Error
#' @description
#' Throws an error using [`cli::cli_abort`] with the error class included in the message.
#' @param cond (`error`)\cr
#'   The error object.
#' @export
stop_with_class = function(cond) {
  cli::cli_abort(c(
    "x" = cond$message,
    "i" = paste0("Class: ", class(cond)[1L])
  ), call = NULL)
}

#' @title Throw Warning
#' @description
#' Throws a warning using [`cli::cli_warn`] with the warning class included in the message.
#' @param cond (`error`)\cr
#'   The warning object.
#' @export
warn_with_class = function(cond) {
  cli::cli_warn(c(
    "x" = cond$message,
    "i" = paste0("Class: ", class(cond)[1L])
  ), call = NULL)
}
