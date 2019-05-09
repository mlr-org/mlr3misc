#' @title Does a list contain an object?
#'
#' @description
#' Simply checks if a list contains a given object.
#'
#' * NB1: Objects are compared with identity.
#' * NB2: Only use this on lists with complex objects, for simpler structures
#'   there are faster operations.
#' * NB3: Clones of R6 objects are not detected.
#'
#' @inheritParams map
#' @param .y (any):
#'   Object to test for
#' @export
has_element = function(.x, .y) {
  for (i in seq_along(.x)) {
    if (identical(.x[[i]], .y))
      return(TRUE)
  }
  return(FALSE)
}
