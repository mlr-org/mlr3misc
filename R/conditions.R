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
  stop(condition)
}

#' @rdname mlr_conditions
#' @export
error_timeout = function(silent = FALSE) {
  condition <- mlr3_error("reached elapsed time limit", class = "mlr3ErrorTimeout")
  if (silent) {
    return(condition)
  }
  stop(condition)
}

#' @rdname mlr_conditions
#' @export
mlr3_error = function(msg, ..., class = NULL) {
  errorCondition(sprintf(msg, ...), class = c(class, "mlr3Error"))
}

#' @rdname mlr_conditions
#' @export
mlr3_warning = function(msg, ..., class = NULL) {
  warningCondition(sprintf(msg, ...), class = c(class, "mlr3Warning"))
}
