#' @title Isolate a Function from its Environment
#'
#' @description
#' Put a function in a "lean" environment that does not carry unnecessary baggage with it (e.g. references to datasets).
#'
#' @param .fn (`function()`)\cr
#'   function to crate
#' @param ... (any)\cr
#'   The objects, which should be visible inside `.fn`.
#' @param .parent (`environment`)\cr
#'   Parent environment to look up names. Default to [topenv()].
#'
#' @export
#' @examples
#' meta_f = function(z) {
#'   x = 1
#'   y = 2
#'   crate(function() {
#'     c(x, y, z)
#'   }, x)
#' }
#' x = 100
#' y = 200
#' z = 300
#' f = meta_f(1)
#' f()
crate = function(.fn, ..., .parent = topenv()) {
  nn = map_chr(substitute(list(...)), as.character)[-1L]
  environment(.fn) = list2env(setNames(list(...), nn), parent = .parent)
  .fn
}
