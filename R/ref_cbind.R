#' @title Bind Columns by Reference
#'
#' @description
#' Performs [base::cbind()] on [data.tables][data.table::data.table()], possibly by reference.
#'
#' @param x :: [data.table::data.table()]\cr
#'   [data.table::data.table()] to add columns to.
#' @param y :: [data.table::data.table()]\cr
#'   [data.table::data.table()] to take columns from.
#'
#' @return ([data.table::data.table()]): Updated `x` .
#' @export
rcbind = function(x, y) {

  assert_data_table(x)
  assert_data_table(y)

  if (ncol(x) == 0L) {
    return(y)
  }

  if (ncol(y) == 0L) {
    return(x)
  }

  if (nrow(x) != nrow(y)) {
    stopf("Tables have different number of rows (x: %i, y: %i)",
      nrow(x), nrow(y))
  }

  ii = which(names(x) %in% names(y))
  if (length(ii)) {
    stopf("Duplicated names: %s", paste0(names(x[ii]), collapse = ","))
  }

  x[, names(y) := y][]
}
