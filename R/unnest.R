#' @title Unnest List Data Table Columns
#'
#' @description
#' Transforms list columns to separate columns, possibly by reference.
#' The original columns are removed from the returned table.
#'
#' @param x :: [data.table::data.table()]\cr
#'   [data.table::data.table()] with columns to unnest.
#' @param cols :: `character()`\cr
#'   Column names of list columns to operate on.
#' @param prefix :: `character(1)`\cr
#'   String to prefix the new column names with.
#'
#' @return ([data.table::data.table()]).
#' @export
#' @examples
#' x = data.table::data.table(
#'   id = 1:2,
#'   value = list(list(a = 1, b = 2), list(a = 2, b = 2))
#' )
#' print(x)
#' unnest(x, "value")
unnest = function(x, cols, prefix = NULL) {
  assert_data_table(x)
  assert_subset(cols, names(x))
  assert_string(prefix, null.ok = TRUE)

  for (col in intersect(cols, names(x))) {
    values = x[[col]]
    if (!is.list(values)) {
      next
    }

    tmp = safe_rbindlist(values)
    if (!is.null(prefix)) {
      setnames(tmp, names(tmp), paste0(prefix, names(tmp)))
    }

    x = rcbind(remove_named(x, col), tmp)
  }

  x[]
}

safe_rbindlist = function(values) {
  new_cols = rbindlist(lapply(values, function(row) {
    # preserve row, we need at least one value
    if (all(lengths(row) == 0L)) {
      return(list("__dummy__" = NA))
    }

    # wrap non-atomics into an extra list
    ii = which(!map_dbl(row, is.atomic))
    row[ii] = lapply(row[ii], list)
    row
  }), fill = TRUE, use.names = TRUE)

  remove_named(new_cols, "__dummy__")
}
