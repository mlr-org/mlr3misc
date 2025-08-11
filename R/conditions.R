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
#' @export
error_config = function(msg, ..., class = NULL) {
  stop(condition_config(msg, ..., class = class))
}

#' @rdname mlr_conditions
#' @export
condition_config = function(msg, ..., class = NULL) {
  condition_mlr3(msg, ..., class = c(class, "mlr3ErrorConfig"))
}

#' @rdname mlr_conditions
#' @export
error_timeout = function() {
  stop(condition_timeout())
}

#' @rdname mlr_conditions
#' @export
condition_timeout = function() {
  condition_mlr3("reached elapsed time limit", class = "mlr3ErrorTimeout")
}

#' @rdname mlr_conditions
#' @export
error_mlr3 = function(msg, ..., class = NULL) {
  stop(condition_mlr3(msg, ..., class = class))
}

#' @rdname mlr_conditions
#' @export
condition_mlr3 = function(msg, ..., class = NULL) {
  errorCondition(sprintf(msg, ...), class = c(class, "mlr3Error"))
}
