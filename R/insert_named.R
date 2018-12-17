#' @title Insert or remove named elements
#'
#' @description
#' Insert elements from `y` into `x` by name, or remove elements from `x` by name.
#' Works for lists, environments and data frames and data tables.
#' Objects with reference semantic (`environment` and `data.table`) are changed in-place.
#'
#' @param x (`list()` | `environment` | `data.table`]: Object to insert elements into.
#'  Changes are by-reference for environments and data tables.
#' @param y (`list()`): List of element to insert into `x`.
#' @param nn (`character()`): Character vector of elements to remove.
#'
#' @return Updated object.
#' @export
insert_named = function(x, y) {
  if (length(y) == 0L)
    return(x)
  assert_names(names(y), type = "unique")
  UseMethod("insert_named")
}

#' @export
#' @rdname insert_named
insert_named.default = function(x, y) {
  assert_vector(x, names = "unique")
  x[names(y)] = y
  x
}

#' @export
#' @rdname insert_named
insert_named.environment = function(x, y) {
  for (nn in names(y))
    assign(nn, y[[nn]], envir = x)
  x
}

#' @export
#' @rdname insert_named
insert_named.data.frame = function(x, y) {
  if (ncol(x) > 0L) {
    x[names(y)] = as.list(y)
    as.data.frame(x)
  } else {
    as.data.frame(y)
  }
}

#' @export
#' @rdname insert_named
insert_named.data.table = function(x, y) {
  if (ncol(x) > 0L) {
    ..y = y
    x[, names(..y) := ..y][]
  } else { # null data.table, we cannot assign with `:=`
    as.data.table(y)
  }
}