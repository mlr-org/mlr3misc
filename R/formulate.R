#' @title Create Formulas
#'
#' @description
#' Given the left-hand side and right-hand side as character vectors, generates a new
#' [stats::formula()].
#'
#' @param lhs (`character(1)`)\cr
#'   Left-hand side of formula.
#' @param rhs (`character()`)\cr
#'   Right-hand side of formula. Multiple elements will be collapsed with `" + "`.
#' @param env (`environment()`)\cr
#'   Environment for the new formula. Defaults to `NULL`.
#'
#' @return [stats::formula()].
#' @export
#' @examples
#' formulate("Species", c("Sepal.Length", "Sepal.Width"))
#' formulate(rhs = c("Sepal.Length", "Sepal.Width"))
formulate = function(lhs = NULL, rhs = NULL, env = NULL) {
  if (length(lhs) == 0L) {
    lhs = ""
  }
  if (length(rhs) == 0L) {
    rhs = "1"
  }
  f = as.formula(sprintf("%s ~ %s", lhs, paste0(rhs, collapse = " + ")))
  environment(f) = env
  f
}
