#' @title Unnest List Columns
#'
#' @description
#' Transforms list columns to separate columns, possibly by reference.
#' The original columns are removed from the returned table.
#' All non-atomic objects in the list columns are expanded to new list columns.
#'
#' @param x ([data.table::data.table()])\cr
#'   [data.table::data.table()] with columns to unnest.
#' @param cols (`character()`)\cr
#'   Column names of list columns to operate on.
#' @param prefix (`logical(1)` | `character(1)`)\cr
#'   String to prefix the new column names with.
#'   Use `"{col}"` (without the quotes) as placeholder for the original column name.
#'
#' @return ([data.table::data.table()]).
#' @export
#' @examples
#' x = data.table::data.table(
#'   id = 1:2,
#'   value = list(list(a = 1, b = 2), list(a = 2, b = 2))
#' )
#' print(x)
#' unnest(data.table::copy(x), "value")
#' unnest(data.table::copy(x), "value", prefix = "{col}.")
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
      setnames(tmp, paste0(gsub("{col}", col, prefix, fixed = TRUE), names(tmp)))
    }

    # rcbind checks for duplicated column names
    x = rcbind(remove_named(x, col), tmp)
  }

  x[]
}

rbindlist2 = function(values) {
  # only rows with empty, non-atomic, or multi-element values need to be fixed up,
  # rows consisting of length-1 atomics can be passed to rbindlist() as is
  row_n = lengths(values)
  flat = unlist(values, recursive = FALSE, use.names = FALSE)
  dirty = if (length(flat) == sum(row_n)) {
    el_dirty = lengths(flat) != 1L | !vapply(flat, is.atomic, NA, USE.NAMES = FALSE)
    row_n == 0L | seq_along(values) %in% rep.int(seq_along(values), row_n)[el_dirty]
  } else {
    rep.int(TRUE, length(values))
  }
  values[dirty] = lapply(values[dirty], rbindlist2_fix_row)

  new_cols = rbindlist(values, fill = TRUE, use.names = TRUE)
  remove_named(new_cols, "__rbindlist2_dummy__")
}

rbindlist2_fix_row = function(row) {
  n = lengths(row)
  # to preserve the row, we need at least one value
  if (all(n == 0L)) {
    return(list("__rbindlist2_dummy__" = NA))
  }

  # wrap non-atomics or multi-element atomics into an extra list
  ii = which(!map_lgl(row, is.atomic) | n > 1L)
  if (length(ii)) {
    row[ii] = lapply(row[ii], list)
  }

  row
}
