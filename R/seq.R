#' @title Sequence construction helpers for mlr3
#'
#' @description
#' `seq_row()` creates a sequence along the number of rows of `x`,
#' `seq_col()` a sequence along the number of columns of `x`.
#' `seq_len0()` and `seq_along0()` are the 0-based counterparts to [base::seq_len()] and
#' [base::seq_along()].
#'
#' @param x \[any]:\cr
#'  Arbitrary object. Used to query its rows, cols or length.
#' @param n \[integer(1)\]:\cr
#'  Length of the sequence.
#' @name sequence_helpers
NULL

#' @export
#' @rdname sequence_helpers
seq_row = function(x) {
  seq_len(nrow(x))
}

#' @export
#' @rdname sequence_helpers
seq_col = function(x) {
  seq_len(ncol(x))
}

#' @export
#' @rdname sequence_helpers
seq_len0 = function(n) {
  n = assert_int(n, coerce = TRUE)
  if (n >= 1L) seq(from = 0L, to = n - 1L) else integer(0L)
}

#' @export
#' @rdname sequence_helpers
seq_along0 = function(x) {
  seq_len0(length(x))
}
