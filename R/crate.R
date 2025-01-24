#' @title Isolate a Function from its Environment
#'
#' @description
#' Put a function in a "lean" environment that does not carry unnecessary baggage with it (e.g. references to datasets).
#'
#' @param .fn (`function()`)\cr
#'   function to crate
#' @param ... (`any`)\cr
#'   The objects, which should be visible inside `.fn`.
#' @param .parent (`environment`)\cr
#'   Parent environment to look up names. Default to [topenv()].
#' @param .compile (`logical(1)`)\cr
#'   Whether to jit-compile the function.
#'   In case the function is already compiled.
#'   If the input function `.fn` is compiled, this has no effect, and the output function will always be compiled.
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
crate = function(.fn, ..., .parent = topenv(parent.frame()), .compile = TRUE) {
  assert_flag(.compile)
  .compile = .compile || is_compiled(.fn)
  nn = map_chr(substitute(list(...)), as.character)[-1L]
  environment(.fn) = list2env(setNames(list(...), nn), parent = .parent)
  if (.compile) {
    .fn = compiler::cmpfun(.fn)
  }
  return(.fn)
}

is_compiled = function(x) {
  tryCatch({
    capture.output(compiler::disassemble(x))
    TRUE
  }, error = function(e) FALSE)
}
