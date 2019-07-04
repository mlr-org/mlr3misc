#' @title A Type-Stable names() Replacement
#'
#' @description
#' A simple wrapper around [base::names()].
#' Returns a character vector even if no names attribute is set.
#' Values `NA` and `""` are treated as missing and replaced with the value provided in `missing_val`.
#'
#' @param x :: `any`\cr
#'   Object.
#' @param missing_val :: `atomic(1)`\cr
#'   Value to set for missing names.
#'   Default is `NA_character_`.
#'
#' @return (`character(length(x))`).
#' @export
#' @examples
#' x = 1:3
#' names(x)
#' names2(x)
#'
#' names(x)[1:2] = letters[1:2]
#' names(x)
#' names2(x, missing_val = "")
names2 = function(x, missing_val = NA_character_) {
  n = names(x)
  if (is.null(n)) {
    return(rep.int(missing_val, length(x)))
  }
  replace(n, is.na(n) | !nzchar(n), missing_val)
}
