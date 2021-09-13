#' @title Convert a Named Vector into a data.table and Vice Versa
#'
#' @description
#' `enframe()` returns a [data.table::data.table()] with two columns:
#' The names of `x` (or `seq_along(x)` if unnamed) and the values of `x`.
#'
#' `deframe()` converts a two-column data.frame to a named vector.
#' If the data.frame only has a single column, an unnamed vector is returned.
#'
#'
#' @param x (`vector()` (`enframe()`) or `data.frame()` (`deframe()`))\cr
#'   Vector to convert to a [data.table::data.table()].
#' @param name (`character(1)`)\cr
#'   Name for the first column with names.
#' @param value (`character(1)`)\cr
#'   Name for the second column with values.
#'
#' @return [data.table::data.table()] or named `vector`.
#' @export
#' @examples
#' x = 1:3
#' enframe(x)
#'
#' x = set_names(1:3, letters[1:3])
#' enframe(x, value = "x_values")
enframe = function(x, name = "name", value = "value") {
  if (is.environment(x)) {
    x = as.list(x)
  }
  dt = data.table(names(x) %??% seq_along(x), unname(x))
  setnames(dt, c(name, value))[]
}

#' @rdname enframe
#' @export
deframe = function(x) {
  assert_data_frame(x)
  nc = ncol(x)

  if (nc == 1L) {
    x[[1L]]
  } else if (nc == 2L) {
    setNames(x[[2L]], x[[1L]])
  } else {
    stopf("Data frame must have 1 or 2 columns, but has %i columns", nc)
  }
}
