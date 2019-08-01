#' @title Set Names
#'
#' @description
#' Sets the names (or colnames) of `x` to `nm`.
#' If `nm` is a function, it is used to transform the already existing names of `x`.
#'
#' @param x :: `any`.\cr
#'   Object to set names for.
#' @param nm :: (`character()` | `function()`)\cr
#'   New names, or a function which transforms already existing names.
#' @param ... :: `any`\cr
#'   Passed down to `nm` if `nm` is a function.
#'
#' @return `x` with updated names.
#'
#' @export
#' @examples
#' x = letters[1:3]
#'
#' # name x with itself:
#' x = set_names(x)
#' print(x)
#'
#' # convert names to uppercase
#' x = set_names(x, toupper)
#' print(x)
set_names = function(x, nm = x, ...) {
  if (is.function(nm)) {
    nm = map_chr(names2(x), nm)
  }
  names(x) = nm
  x
}


#' @rdname set_names
#' @export
set_col_names = function (x, nm, ...) {
    if (is.function(nm)) {
      nm = map_chr(names2(x), nm)
    }
    colnames(x) = nm
    x
}
