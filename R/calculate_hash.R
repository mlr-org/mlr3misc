#' @title Calculate a Hash for Multiple Objects
#'
#' @description
#' Calls [digest::digest()] using the 'xxhash64' algorithm after applying [`hash_input`] to each object.
#' To customize the hashing behaviour, you can overwrite [`hash_input`] for specific classes.
#' For `data.table` objects, [`hash_input`] is applied to all columns, so you can overwrite [`hash_input`] for
#' columns of a specific class.
#' Objects that don't have a specific method are hashed as is.
#'
#' @param ... (`any`)\cr
#'   Objects to hash.
#' @param .list (`list()`)\cr
#'   Additional objects to hash.
#'
#' @return (`character(1)`).
#' @export
#' @examples
#' calculate_hash(iris, 1, "a")
calculate_hash = function(..., .list = list()) {
  digest(lapply(c(list(...), .list), hash_input), algo = "xxhash64")
}

#' Hash Input
#'
#' Returns the part of an object to be used to calculate its hash.
#'
#' @param x (`any`)\cr
#'   Object for which to retrieve the hash input.
#' @export
hash_input = function(x) {
  UseMethod("hash_input")
}

#' @describeIn hash_input
#' The formals and the body are returned in a `list()`.
#' This ensures that the bytecode or parent environment are not included.
#' in the hash.
#' @export
hash_input.function = function(x) {
  list(formals(x), as.character(body(x)))
}

#' @describeIn hash_input
#' The data.table is converted to a regular list and `hash_input()` is applied to all elements.
#' The conversion to a list ensures that keys and indices are not included in the hash.
#' @export
#' @method hash_input data.table
hash_input.data.table = function(x) {
  lapply(as.list(x), hash_input)
}

#' @describeIn hash_input
#' Returns the object as is.
#' @export
hash_input.default = function(x) {
  x
}

#' @describeIn hash_input
#' If the R6 object has a `$hash` slot, it is returned.
#' Otherwise, the object is returned as is.
#' @export
hash_input.R6 = function(x) {
  # In the following we also avoid accessing `val$hash` twice, because it could
  # potentially be an expensive AB.
  get0("hash", x, mode = "any", inherits = FALSE, ifnotfound = x)
}
