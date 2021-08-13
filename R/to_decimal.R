#' @title Convert a Vector of Bits to a Decimal Number
#'
#' @description
#' Converts a logical vector from binary to decimal.
#' The bit vector may have any length, the last position is the least significant, i.e.
#' bits are multiplied with `2^(n-1)`, `2^(n-2)`, ..., `2^1`, `2^0` where `n` is the
#' length of the bit vector.
#'
#' @param bits (`logical()`)\cr
#'   Logical vector of input values. Missing values are treated as being `FALSE`.
#'   If `bits` is longer than 30 elements, an exception is raised.
#'
#' @return (`integer(1)`).
#'
#' @useDynLib mlr3misc c_to_decimal
#' @export
to_decimal = function(bits) {
  bits = as.logical(bits)
  .Call(c_to_decimal, bits, PACKAGE = "mlr3misc")
}
