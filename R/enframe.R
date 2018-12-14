#' @title Convert a named vector into a data.table
#'
#' @description
#' Returns a [data.table::data.table()] with two columns:
#' The names of `x` (or seq along `x` if unnamed) and the values of `x`.
#'
#' @param x (`vector()`).
#' @param name (`character(1)`): Name for the first column with names.
#' @param value (`character(1)`): Name for the second column with values.
#'
#' @return [data.table::data.table()].
#' @export
#' @examples
#' x = 1:3
#' enframe(x)
#'
#' x = set_names(1:3, letters[1:3])
#' enframe(x, value = "x_values")
enframe = function(x, name = "name", value = "value") {
  dt = data.table(names(x) %??% seq_along(x), unname(x))
  setnames(dt, c(name, value))[]
}
