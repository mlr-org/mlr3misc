#' @title Count Missing Values in a Vector
#'
#' Same as `sum(is.na(x))`, but without the allocation.
#'
#' @param x [`vector()`]\cr
#'   Supported are logical, integer, double, complex and string vectors.
#' @return (`integer(1)`) number of missing values.
#'
#' @useDynLib mlr3misc c_count_missing
#' @export
#' @examples
#' count_missing(c(1, 2, NA, 4, NA))
count_missing = function(x) {
  .Call(c_count_missing, x, PACKAGE = "mlr3misc")
}
