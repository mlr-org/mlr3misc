#' @title Get Distinct Values
#'
#' @description
#' Extracts the distinct values of an atomic vector, with the possibility to drop levels
#' and remove missing values.
#'
#' @param x :: atomic `vector()`.
#' @param drop :: `logical(1)`\cr
#'   If `TRUE`, only returns values which are present in `x`.
#'   If `FALSE`, returns all levels for [factor()] and [ordered()], as well as
#'   `TRUE` and `FALSE` for [logical()]s.
#' @param na_rm :: `logical(1)`\cr
#'   If `TRUE`, missing values are removed from the vector of distinct values.
#'
#' @return (atomic `vector()`) with distinct values in no particular order.
#' @export
#' @examples
#' # for factors:
#' x = factor(c(letters[1:2], NA), levels = letters[1:3])
#' distinct_values(x)
#' distinct_values(x, na_rm = FALSE)
#' distinct_values(x, drop = FALSE)
#' distinct_values(x, drop = FALSE, na_rm = FALSE)
#'
#' # for logicals:
#' distinct_values(TRUE, drop = FALSE)
#'
#' # for numerics:
#' distinct_values(sample(1:3, 10, replace = TRUE))
distinct_values = function(x, drop = TRUE, na_rm = TRUE) {
  assert_flag(drop)
  assert_flag(na_rm)
  UseMethod("distinct_values")
}

#' @export
distinct_values.default = function(x, drop = TRUE, na_rm = TRUE) {
  lvls = unique(x)
  if (na_rm)
    lvls = lvls[!is.na(lvls)]
  lvls
}

#' @export
distinct_values.logical = function(x, drop = TRUE, na_rm = TRUE) {
  if (!drop) {
    lvls = c(TRUE, FALSE)
    if (!na_rm && anyMissing(x))
      lvls = c(lvls, NA)
  } else {
    lvls = unique(x)
    if (na_rm)
      lvls = lvls[!is.na(lvls)]
  }
  lvls
}

#' @export
distinct_values.factor = function(x, drop = TRUE, na_rm = TRUE) {
  if (drop) {
    lvls = as.character(unique(x))
    if (na_rm)
      lvls = lvls[!is.na(lvls)]
  } else {
    lvls = levels(x)
    if (!na_rm && anyMissing(x))
      lvls = c(lvls, NA_character_)
  }
  lvls
}


