#' @title Insert or Remove Named Elements
#'
#' @description
#' Insert elements from `y` into `x` by name, or remove elements from `x` by name.
#' Works for vectors, lists, environments and data frames and data tables.
#' Objects with reference semantic (`environment()` and [data.table::data.table()]) might be modified in-place.
#'
#' @param x (`vector()` | `list()` | `environment()` | [data.table::data.table()])\cr
#'   Object to insert elements into, or remove elements from.
#'   Changes are by-reference for environments and data tables.
#' @param y (`list()`)\cr
#'   List of elements to insert into `x`.
#' @param nn (`character()`)\cr
#'   Character vector of elements to remove.
#'
#' @return Modified object.
#' @export
#' @examples
#' x = list(a = 1, b = 2)
#' insert_named(x, list(b = 3, c = 4))
#' remove_named(x, "b")
insert_named = function(x, y) {
  if (length(y) == 0L) {
    return(x)
  }
  assert_names(names(y), type = "unique")
  UseMethod("insert_named")
}

#' @export
#' @rdname insert_named
insert_named.NULL = function(x, y) { # nolint
  if (!test_named(y)) {
    stopf("insert_named(NULL, y) failed: 'y' is unnamed")
  }
  y
}

#' @export
#' @rdname insert_named
insert_named.default = function(x, y) { # nolint
  assert_vector(x, names = "unique")
  x[names(y)] = y
  x
}

#' @export
#' @rdname insert_named
insert_named.environment = function(x, y) { # nolint
  for (nn in names(y)) {
    assign(nn, y[[nn]], envir = x)
  }
  x
}

#' @export
#' @rdname insert_named
insert_named.data.frame = function(x, y) { # nolint
  if (ncol(x) > 0L) {
    x[names(y)] = as.list(y)
    as.data.frame(x)
  } else {
    as.data.frame(y)
  }
}

#' @export
#' @rdname insert_named
insert_named.data.table = function(x, y) { # nolint
  if (ncol(x) > 0L) {
    ..y = y
    x[, names(..y) := ..y][]
  } else { # null data.table, we cannot assign with `:=`
    as.data.table(y)
  }
}
