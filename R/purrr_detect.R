#' Does a list contain an object?
#'
#' @description
#' * NB1: Objects are compared with identity.
#' * NB2: Only use this on lists with complex objects, for simpler structures there are faster operations.
#' * NB3: Clones of R6 objects are not detected.
#'
#' @inheritParams map
#' @param .y Object to test for
#' @export
has_element <- function(.x, .y) {
  # actually, fastest option would be to for-loop over the list, and break on detection,
  # but i guess that we would need to do in C code...
  any(map_lgl(.x, identical, y = .y))
}
