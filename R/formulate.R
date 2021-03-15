#' @title Create Formulas
#'
#' @description
#' Given the left-hand side and right-hand side as character vectors, generates a new
#' [stats::formula()].
#'
#' @param lhs (`character()`)\cr
#'   Left-hand side of formula. Multiple elements will be collapsed with `" + "`.
#' @param rhs (`character()`)\cr
#'   Right-hand side of formula. Multiple elements will be collapsed with `" + "`.
#' @param env (`environment()`)\cr
#'   Environment for the new formula. Defaults to `NULL`.
#' @param env (`environment()`)\cr
#'   Environment for the new formula. Defaults to `NULL`.
#' @param quote (`character(1)`)\cr
#'   Which side of the formula to quote?
#'   Subset of `("left", "right")`, defaulting to `"right"`.
#' @return [stats::formula()].
#' @export
#' @examples
#' formulate("Species", c("Sepal.Length", "Sepal.Width"))
#' formulate(rhs = c("Sepal.Length", "Sepal.Width"))
formulate = function(lhs = character(), rhs = character(), env = NULL, quote = "right") {
  assert_subset(quote, choices = c("left", "right"))
  lhs = as.character(lhs)
  rhs = as.character(rhs)

  if (length(lhs) == 0L) {
    lhs = ""
  } else if ("left" %in% quote) {
    lhs = paste0("`", lhs, "`")
  }

  if (length(rhs) == 0L) {
    rhs = "1"
  } else if ("right" %in% quote && !identical(rhs, "1")) {
    rhs = paste0("`", rhs, "`")
  }

  f = as.formula(sprintf("%s ~ %s",
      paste0(lhs, collapse = " + "),
      paste0(rhs, collapse = " + "))
  )
  environment(f) = env
  f
}
