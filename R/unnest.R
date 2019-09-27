#' @title Unnest List Data Table Columns
#'
#' @description
#' Transforms list columns to separate columns, possibly by reference.
#' The original columns are removed from the returned table.
#' All non-atomic objects in the list columns are expand to new list column.
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

    tmp = rbindlist2(values)
    if (!is.null(prefix)) {
      setnames(tmp, names(tmp), paste0(prefix, names(tmp)))
    }

    # rcbind checks for duplicated column names
    x = rcbind(remove_named(x, col), tmp)
  }

  x[]
}

rbindlist2 = function(values) {
  new_cols = rbindlist(lapply(values, function(row) {
    # to preserve the row, we need at least one value
    if (all(lengths(row) == 0L)) {
      return(list("__rbindlist2_dummy__" = NA))
    }

    # wrap non-atomics into an extra list
    ii = which(!map_lgl(row, is.atomic))
    if (length(ii)) {
      row[ii] = lapply(row[ii], list)
    }

    row
  }), fill = TRUE, use.names = TRUE)

  remove_named(new_cols, "__rbindlist2_dummy__")
}
