#' @title Cross-Join for data.table
#'
#' @description
#' A safe version of [data.table::CJ()] in case a column is called
#' `sorted` or `unique`.
#'
#' @param dots (named `list()`)\cr
#'   Vectors to cross-join.
#' @param sorted (`logical(1)`)\cr
#'   See [data.table::CJ()].
#' @param unique (`logical(1)`)\cr
#'   See [data.table::CJ()].
#' @return [data.table::data.table()].
#' @export
#' @examples
#' cross_join(dots = list(sorted = 1:3, b = letters[1:2]))
cross_join = function(dots, sorted = TRUE, unique = FALSE) {
  assert_list(dots, names = "unique")
  nn = names(dots)
  tab = invoke(CJ, sorted = sorted, unique = unique, .args = unname(dots))
  setnames(tab, nn)[]
}
