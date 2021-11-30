#' @title Extract Private Fields of R6 Objects
#'
#' @description
#' Provides access to the private members of [R6::R6Class] objects.
#'
#' @param x (any)\cr
#'   Object to extract the private members from.
#'
#' @return `environment()` of private members, or `NULL` if `x` is not an R6 object.
#' @export
#' @examples
#' library(R6)
#' item = R6Class("Item", private = list(x = 1))$new()
#' get_private(item)$x
get_private = function(x) {
  if (!inherits(x, "R6")) {
    return(NULL)
  }

  x[[".__enclos_env__"]][["private"]]
}
