#' @title Composition of Functions
#'
#' @description
#' Composes two or more functions into a single function.
#' The returned function calls all provided functions in reverse order:
#' The return value of the last function servers as input
#' for the next to last function, and so on.
#'
#' @param ... (`functions`)\cr
#'   Functions to compose.
#'
#' @return (`function()`) which calls the functions provided via `...`
#' in reverse order.
#'
#' @export
#' @examples
#' f = compose(function(x) x + 1, function(x) x / 2)
#' f(10)
compose = function(...) {
  funs = rev(lapply(list(...), match.fun))
  assert_list(funs, min.len = 1L)

  function(...) {
    out = funs[[1L]](...)

    out = funs[[1]](...)
    for (f in tail(funs, length(funs) - 1L)) {
      out = f(out)
    }

    out
  }
}
