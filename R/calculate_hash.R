#' @title Calculate a Hash for Multiple Objects
#'
#' @description
#' Calls [digest::digest()] to calculate the hash for all objects provided.
#'
#' The following operations are performed to make hashing more robust:
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
  digest(lapply(list(...), function(x) {
    if (is.function(x)) {
      list(formals(x), as.character(body(x)))
    } else if (is.data.table(x)) {
      as.list(x)
    } else {
      x
    }
  }), algo = "xxhash64")
}
