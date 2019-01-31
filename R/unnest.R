#' @title Unnest list data table columns
#'
#' Transforms each element of a list columns into its own column, possibly
#' by reference.
#'
#' @param x ([data.table::data.table()]): `data.table` with columns to unnest.
#' @param cols (`character()`): Column names of list columns to unnest.
#' @return Updated `x` (`data.table`).
#' @export
unnest = function(x, cols) {
  assert_data_table(x)
  for (col in intersect(cols, names(x))) {
    x[lengths(get(col)) == 0L, (col) := list(list(list("__dummy__" = NA)))]
    tmp = rbindlist(x[[col]], fill = TRUE)
    x = ref_cbind(remove_named(x, col), remove_named(tmp, "__dummy__"))
  }
  x[]
}
