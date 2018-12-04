#' @title Wrapper for setNames
#'
#' @description
#' Sets the names of `x` to `nm`.
#' If `nm` is a function, it is used to transform the already existing names of `x`.
#'
#' @param x (`vector`).
#' @param nm (`character()` | `function()`).
#' @param ... (any). Passed down to `nm` if it is a function.
#'
#' @return `x` with names set.
#'
#' @export
set_names = function(x, nm = x, ...) {
  if (is.function(nm))
    nm = map_chr(names2(x), nm)
  names(x) = nm
  x
}
