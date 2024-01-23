#' @title Calculate a Hash for Multiple Objects
#'
#' @description
#' Calls [digest::digest()] to calculate the hash for all objects provided.
#' By specifying methods for the [`hash_input`] generic, you can control which information of an object
#' is used to calculate the hash.
#'
#' Methods exist for:
#' * If an object is a [function()], the formals and the body are hashed separately.
#'   This ensures that the bytecode or parent environment are not be included
#'   in the hash.
#' * If an object is a [data.table::data.table()], the data.table is converted to a
#'   regular list. This ensures that keys and indices are not included in the hash.
#'
#' Note that this only applies to top level objects, these transformations are not done
#' recursively.
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
#' Returns the information of an object to be used to calculate its hash.
#' @param x (any)\cr
#'   Object that is part of the object to be hashed.
#' @export
hash_input = function(x) {
  UseMethod("hash_input")
}

#' @export
hash_input.function = function(x) {
  list(formals(x), as.character(body(x)))
}

#' @export
#' @method hash_input data.table
hash_input.data.table = function(x) {
  lapply(as.list(x), hash_input)
}

#' @export
hash_input.default = function(x) {
  x
}

