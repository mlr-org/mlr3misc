#' @title Logical Check Operators
#'
#' @description
#' AND and OR operators for [`checkmate`] `check_*`-functions.
#'
#' @param lhs,rhs (`check_*`-functions)\cr
#'   `check_*`-functions that return either `TRUE` or an error message.
#'
#' @name check_ops
#' @examples
#' check_numeric(x) %check&&% check_true(all(x < 0))
#' check_numeric(x) %check||% check_character(x)
NULL

#' @export
#' @rdname check_ops
`%check&&%` = function(lhs, rhs) {
  if (!isTRUE(lhs) && !isTRUE(rhs)) return(paste0(lhs, ", and ", rhs))
  if (isTRUE(lhs)) rhs else lhs
}

#' @export
#' @rdname check_ops
`%check||%` = function(lhs, rhs) {
  if (!isTRUE(lhs) && !isTRUE(rhs)) return(paste0(lhs, ", or ", rhs))
  TRUE
}
