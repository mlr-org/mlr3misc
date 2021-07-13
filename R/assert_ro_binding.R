#' @title Assertion for Active Bindings in R6 Classes
#'
#' @description
#' This assertion is intended to be called in active bindings of an
#' [R6::R6Class] which does not allow assignment.
#' If `rhs` is not missing, an exception is raised.
#'
#' @param rhs (any)\cr
#'   If not missing, an exception is raised.
#'
#' @return Nothing.
#' @export
assert_ro_binding = function(rhs) {
  if (!missing(rhs)) {
    stop("Field/Binding is read-only")
  }
}
