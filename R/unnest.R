#' @title Unnest List Data Table Columns
#'
#' @description
#' Transforms each element of a list columns into its own column, possibly by reference.
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
  assert_character(cols, any.missing = FALSE)
  assert_string(prefix, null.ok = TRUE)

  for (col in intersect(cols, names(x))) {
    x[lengths(get(col)) == 0L, (col) := list(list(list("__dummy__" = NA)))]
    tmp = remove_named(rbindlist(x[[col]], fill = TRUE, use.names = TRUE), "__dummy__")
    if (!is.null(prefix)) {
      setnames(tmp, names(tmp), paste0(prefix, names(tmp)))
    }
    x = rcbind(remove_named(x, col), tmp)
  }
  x[]
}
