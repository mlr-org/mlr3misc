#' @title Logical Check Operators
#'
#' @description
#' Logical AND and OR operators for `check_*`-functions from [`checkmate`][`checkmate::checkmate`].
#'
#' @param lhs,rhs (`function()`)\cr
#'   `check_*`-functions that return either `TRUE` or an error message as a `character(1)`.
#'
#' @return Either `TRUE` or a `character(1)`.
#'
#' @name check_operators
#' @examples
#' library(checkmate)
#'
#' x = c(0, 1, 2, 3)
#' check_numeric(x) %check&&% check_names(names(x), "unnamed")  # is TRUE
#' check_numeric(x) %check&&% check_true(all(x < 0))  # fails
#'
#' check_numeric(x) %check||% check_character(x)  # is TRUE
#' check_number(x) %check||% check_flag(x)  # fails
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
