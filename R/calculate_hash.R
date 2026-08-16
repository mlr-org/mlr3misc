#' @title Calculate a Hash for Multiple Objects
#'
#' @description
#' Calls [digest::digest()] using the 'xxhash64' algorithm after applying [`hash_input`] to each object.
#' To customize the hashing behavior, you can overwrite [`hash_input`] for specific classes.
#' For `data.table` objects, [`hash_input`] is applied to all columns, so you can overwrite [`hash_input`] for
#' columns of a specific class.
#' Objects that don't have a specific method are hashed as is.
#'
#' @param ... (`any`)\cr
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
#' @param x (`any`)\cr
#'   Object for which to retrieve the hash input.
#' @export
hash_input = function(x) {
  UseMethod("hash_input")
}

#' @describeIn hash_input
#' The formals and the body are returned in a `list()`.
#' This ensures that neither the bytecode nor the parent environment are included in the hash.
#' Source references are removed from the body, so that the hash does not depend on the formatting
#' of the definition or on its position in a source file.
#' Primitives have neither formals nor a body and are returned as is.
#' @export
hash_input.function = function(x) {
  if (is.primitive(x)) {
    return(x)
  }
  # `removeSource()` instead of hashing `as.character(body(x))`: the latter returns the top-level
  # elements of the body, which loses the argument names of a body that is a single call, i.e.
  # `function(x) f(x, a = 1, b = 2)` and `function(x) f(x, b = 1, a = 2)` hash equal
  x = removeSource(x)
  list(formals(x), body(x))
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
