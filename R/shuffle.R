#' @title Safe Version of Sample
#'
#' @description
#' A version of `sample()` which does not treat positive scalar integer `x` differently.
#' See example.
#'
#' @param x :: `vector()`\cr
#'   Vector to sample elements from.
#' @param n :: `integer()`\cr
#'   Number of elements to sample.
#' @param ... :: `any`\cr
#'   Arguments passed down to [base::sample.int()].
#'
#' @export
#' @examples
#' x = 2:3
#' sample(x)
#' shuffle(x)
#'
#' x = 3
#' sample(x)
#' shuffle(x)
shuffle = function(x, n = length(x), ...) {
  x[sample.int(length(x), size = n, ...)]
}
