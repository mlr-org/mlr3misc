#' @title Replace Elements of Vectors with New Values
#'
#' @description
#' Replaces all values in `x` which match `old` with values in `new`.
#' Values are matched with [base::match()].
#'
#' @param x (`vector())`.
#' @param old (`vector()`)\cr
#'   Vector with values to replace.
#' @param new (`vector()`)\cr
#'   Values to replace with.
#'   Will be forced to the same length as `old` with [base::rep_len()].
#'
#' @return (`vector()`) of the same length as `x`.
#' @export
#' @examples
#' x = letters[1:5]
#'
#' # replace all "b" with "_b_", and all "c" with "_c_"
#' old = c("b", "c")
#' new = c("_b_", "_c_")
#' map_values(x, old, new)
map_values = function(x, old, new) {
  assert_atomic_vector(x)
  assert_atomic_vector(old)
  assert_atomic_vector(new)

  i = match(x, old, nomatch = 0L)
  x[i != 0L] = rep_len(new, length(old))[i]
  x
}
