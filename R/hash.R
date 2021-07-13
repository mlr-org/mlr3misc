#' @title Calculate a Hash for Multiple Objects
#'
#' @description
#' Calls [digest::digest()] to calculate the hash for all objects provided.
#' The following operations are performed to make hashing more robust:
#' * If an object is a [function()], the formals and the body are hashed separately.
#'   This ensures that the bytecode or parent environment are not be included
#'   in the hash.
#' * If an object is a [data.table::data.table()], the data.table is converted to a
#'   regular list. This ensures that keys and indices are not included in the hash.
#'
#' @param ... (any)\cr
#'   Objects to hash.
#'
#' @return (`character(1)`).
#' @examples
#' calculate_hash(iris, 1, "a")
calculate_hash = function(...) {
  dots = list(...)
  dots = map_if(dots, is.function, function(fun) {
    list(formals(fun), as.character(body(fun)))
  })
  dots = map_if(dots, is.data.table, as.list)
  digest(dots, algo = "xxhash64")
}
