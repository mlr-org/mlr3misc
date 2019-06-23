#' @title Extract Variables from a Formula
#'
#' @description
#' Given a [formula()] `f`, returns all variables used on the left-hand side and
#' right-hand side of the formula.
#'
#' @param f :: `formula()`.
#'
#' @return (`list()`) with elements `"lhs"` and `"rhs"`, both `character()`.
#' @export
#' @examples
#' extract_vars(Species ~ Sepal.Width + Sepal.Length)
#' extract_vars(Species ~ .)
extract_vars = function(f) {
  assert_formula(f)
  res = named_list(c("lhs", "rhs"))
  res$lhs = if (length(f) == 2L) character(0L) else all.vars(f[[2L]])
  res$rhs = all.vars(f[[length(f)]])
  res
}
