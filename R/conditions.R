#' @title Error Classes
#' @name mlr_conditions
#' @description
#' Condition classes for mlr3.
#'
#' @section Formatting:
#' It is also possible to use formatting options as defined in [`cli::cli_bullets`].
#'
#' @section Errors:
#' * `error_mlr3()` for the base `Mlr3Error` class.
#' * `error_config()` for the `Mlr3ErrorConfig` class, which signals that a user has misconfigured
#'   something (e.g. invalid learner configuration).
#' * `error_input()` for the `Mlr3ErrorInput` if an invalid input was provided.
#'   method.
#' * `error_timeout()` for the `Mlr3ErrorTimeout`, signalling a timeout (encapsulation).
#' * `error_learner()` for the `Mlr3ErrorLearner`, signalling a learner error.
#' * `error_learner_train()` for the `Mlr3ErrorLearner`, signalling a learner training error.
#' * `error_learner_predict()` for the `Mlr3ErrorLearner`, signalling a learner prediction error.
#'
#' @section Warnings:
#' * `warning_mlr3()` for the base `Mlr3Warning` class.
#' * `warning_config()` for the `Mlr3WarningConfig` class, which signals that a user might have
#'   misconfigured something.
#' * `warning_input()` for the `Mlr3WarningInput` if an invalid input might have been provided.
#'
#' @param msg (`character(1)`)\cr
#'   Error message.
#' @param ... (any)\cr
#'   Passed to [`sprintf()`].
#' @param class (`character`)\cr
#'   Additional class(es).
#' @param signal (`logical(1)`)\cr
#'   If `TRUE`, the condition object is returned.
#' @export
error_config = function(msg, ..., class = NULL, signal = TRUE) {
  error_mlr3(msg, ..., class = "Mlr3ErrorConfig", signal = signal)
}

#' @rdname mlr_conditions
#' @export
error_input = function(msg, ..., class = NULL, signal = TRUE) {
  error_mlr3(msg, ..., class = "Mlr3ErrorInput", signal = signal)
}

#' @rdname mlr_conditions
#' @export
error_timeout = function(signal = TRUE) {
  error_mlr3("reached elapsed time limit", class = "Mlr3ErrorTimeout", signal = signal)
}

#' @rdname mlr_conditions
#' @export
error_mlr3 = function(msg, ..., class = NULL, signal = TRUE) {
  cond = errorCondition(sprintf(msg, ...), class = c(class, "Mlr3Error"))
  cond$message = format(cond)
  if (signal) {
    return(stop(cond))
  }
  cond
}

#' @rdname mlr_conditions
#' @export
warning_mlr3 = function(msg, ..., class = NULL, signal = TRUE) {
  cond = warningCondition(sprintf(msg, ...), class = c(class, "Mlr3Warning"))
  cond$message = format(cond)
  if (signal) {
    return(warning(cond))
  }
  cond
}

#' @rdname mlr_conditions
#' @export
warning_config = function(msg, ..., class = NULL, signal = TRUE) {
  warning_mlr3(msg, ..., class = c(class, "Mlr3WarningConfig"), signal = signal)
}

#' @rdname mlr_conditions
#' @export
warning_input = function(msg, ..., class = NULL, signal = TRUE) {
  warning_mlr3(msg, ..., class = c(class, "Mlr3WarningInput"), signal = signal)
}


#' @export
format.Mlr3Error = function(x, ...) {
  message = if (!is.null(names(x$message))) {
    # error message is already a cli list
    message = c(x$message, paste0("Class: ", class(x)[1L]))
    names(message) = c(names(x$message), ">")
    cli::format_bullets_raw(message)
  } else {
    cli::format_bullets_raw(c(
      "x" = x$message,
      ">" = paste0("Class: ", class(x)[1L])
    ))
  }
  paste0("\n", paste0(message, collapse = "\n"), "\n")
}

#' @export
format.Mlr3Warning = format.Mlr3Error

#' @rdname mlr_conditions
#' @export
error_learner = function(msg, ..., class = NULL, signal = TRUE) {
  error_mlr3(msg, ..., class = c(class, "Mlr3ErrorLearner"), signal = signal)
}

#' @rdname mlr_conditions
#' @export
error_learner_train = function(msg, ..., class = NULL, signal = TRUE) {
  error_learner(msg, ..., class = c(class, "Mlr3ErrorLearnerTrain"), signal = signal)
}

#' @rdname mlr_conditions
#' @export
error_learner_predict = function(msg, ..., class = NULL, signal = TRUE) {
  error_learner(msg, ..., class = c(class, "Mlr3ErrorLearnerPredict"), signal = signal)
}
