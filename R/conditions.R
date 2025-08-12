#' @title Error Classes
#' @name mlr_conditions
#' @description
#' Error and warning classes for mlr3.
#' Having these error classes allows us to react differently to different types of errors.
#' For example, we might not want to train a fallback learner if there is a user configuration error,
#' but we do want to train a fallback learner if there is a timeout.
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
  if (signal) {
    return(stop_with_class(cond))
  }
  cond
}

#' @rdname mlr_conditions
#' @export
warning_mlr3 = function(msg, ..., class = NULL, signal = TRUE) {
  cond = warningCondition(sprintf(msg, ...), class = c(class, "Mlr3Warning"))
  if (signal) {
    return(warn_with_class(cond))
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


#' @rdname mlr_condition
#' @title Throw Error
#' @description
#' Throws an error using [`cli::cli_abort`] with the error class included in the message.
#' @param cond (`error`)\cr
#'   The error object.
#' @export
stop_with_class = function(cond) {
  message = if (!is.null(names(cond$message))) {
    # error message is already a cli list
    message = c(cond$message, paste0("Class: ", class(cond)[1L]))
    names(message) = c(names(cond$message), ">")
    cli::format_bullets_raw(message)
  } else {
    cli::format_bullets_raw(c(
      "x" = cond$message,
      ">" = paste0("Class: ", class(cond)[1L])
    ))
  }
  cond$message = paste0("\n", paste0(message, collapse = "\n"), "\n")
  stop(cond)
}

#' @title Throw Warning
#' @description
#' Throws a warning using [`cli::cli_warn`] with the warning class included in the message.
#' @param cond (`error`)\cr
#'   The warning object.
#' @export
warn_with_class = function(cond) {
  message = if (!is.null(names(cond$message))) {
    # error message is already a cli list
    message = c(cond$message, paste0("Class: ", class(cond)[1L]))
    names(message) = c(names(cond$message), ">")
    message
  } else {
    message = cli::format_bullets_raw(c(
      "x" = cond$message,
      ">" = paste0("Class: ", class(cond)[1L])
    ))
  }
  cond$message = paste0("\n", paste0(message, collapse = "\n"), "\n")
  warning(cond)
}
