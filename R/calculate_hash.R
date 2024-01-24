#' @title Calculate a Hash for Multiple Objects
#'
#' @description
#' Calls [digest::digest()] using the 'xxhash64' algorithm after applying [`hash_input()`].
#'
#' @param ... (any)\cr
#'   Objects to hash.
#'
#' @return (`character(1)`).
#' @export
#' @examples
#' calculate_hash(iris, 1, "a")
calculate_hash = function(...) {
  digest(lapply(list(...), hash_input), algo = "xxhash64")
}

#' Hash Input
#'
#' Returns the part of an object to be used to calculate its hash.
#'
#' Methods exist for:
#' @param x (any)\cr
#'   Object for which to retrieve the hash input.
#' @export
hash_input = function(x) {
  UseMethod("hash_input")
}

#' @describeIn hash_input
#' The formals and the body are hashed separately.
#' This ensures that the bytecode or parent environment are not be included
#' in the hash.
#' @export
hash_input.function = function(x) {
  list(formals(x), as.character(body(x)))
}

#' @describeIn hash_input
#' The data.table is converted to a regular list and.
#' This ensures that keys and indices are not included in the hash.
#' Then, [`hash_input`] is applied to each element of the list.
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

