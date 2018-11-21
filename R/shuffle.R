#' @title A safe version of sample
#'
#' @description
#' A version of `sample()` which does not treat scalar integer `x` specially.
#'
#' @param x \[`vector`\]:\cr
#'  Vector to sample elements from.
#' @param n \[`integer`\]:\cr
#'  Number of elements to sample.
#' @param ... \[any\]:\cr
#'  Arguments passed down to [base::sample.int()].
#'
#' @export
shuffle = function(x, n = length(x), ...) {
  x[sample.int(length(x), size = n, ...)]
}
