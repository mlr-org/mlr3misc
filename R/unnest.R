#' @title Unnest list data table columns
#'
#' Transforms each element of a list columns into its own column
#' by reference.
#'
#' @param x ([data.table::data.table()]):\cr
#'  `data.table` with columns to unnest.
#' @param cols (`character()`):\cr
#'  Column names of list columns to unnest.
#' @return Updated `x` (`data.table`).
#' @export
unnest = function(x, cols) {
  assert_data_table(x)
  for (col in intersect(cols, names(x))) {
    tmp = rbindlist(x[[col]], fill = TRUE)
    x[, (col) := NULL]
    ref_cbind(x, tmp)
  }
  x[]
}
