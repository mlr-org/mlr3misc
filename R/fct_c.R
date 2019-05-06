#' @title Combine factor vectors
#'
#' @description
#' Takes multiple vectors of type `factor` or `character` and combines them
#' into a single factor. Levels are merged.
#'
#' @param ... (two or more objects of type `factor()` or `character()`).
#'
#' @return (`factor()`).
#' @export
#' @examples
#' x = factor(c("a", "b", "a"))
#' y = factor(c("b", "a", "a"))
#' z = factor(c("a", "b", "c"))
#'
#' fct_c(x, y)
#' fct_c(x, z)
fct_c = function(...) {
  dots = list(...)
  qassertr(dots, c("f", "s"))
  lvls = unique(unlist(lapply(dots, function(x) if (is.factor(x)) levels(x) else unique(x))))
  factor(do.call(c, lapply(dots, as.character)), levels = lvls)
}
