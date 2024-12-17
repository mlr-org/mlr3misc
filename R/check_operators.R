#' @title Logical Check Operators
#'
#' @description
#' Logical AND and OR operators for `check_*`-functions from [`checkmate`].
#'
#' @param lhs,rhs (`function()`)\cr
#'   `check_*`-functions that return either `TRUE` or an error message.
#'
#' @name check_operators
#' @examples
#' check_numeric(x) %check&&% check_true(all(x < 0))
#' check_numeric(x) %check||% check_character(x)
NULL

#' @export
#' @rdname check_operators
`%check&&%` = function(lhs, rhs) {
  if (!isTRUE(lhs) && !isTRUE(rhs)) return(paste0(lhs, ", and ", rhs))
  if (isTRUE(lhs)) rhs else lhs
}

#' @export
#' @rdname check_operators
`%check||%` = function(lhs, rhs) {
  if (!isTRUE(lhs) && !isTRUE(rhs)) return(paste0(lhs, ", or ", rhs))
  TRUE
}
