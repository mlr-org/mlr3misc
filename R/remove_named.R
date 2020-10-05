#' @export
#' @rdname insert_named
remove_named = function(x, nn) {
  if (length(nn) == 0L) {
    return(x)
  }
  assert_character(nn, any.missing = FALSE)
  UseMethod("remove_named")
}

#' @export
remove_named.default = function(x, nn) { # nolint
  assert_vector(x, names = "unique")
  x[setdiff(names(x), nn)]
}

#' @export
#' @rdname insert_named
remove_named.environment = function(x, nn) { # nolint
  rm(list = intersect(ls(envir = x, all.names = TRUE), nn), envir = x)
  x
}

#' @export
#' @rdname insert_named
remove_named.data.frame = function(x, nn) { # nolint
  nn = setdiff(names(x), nn)
  x[, nn, drop = FALSE]
}

#' @export
#' @rdname insert_named
remove_named.data.table = function(x, nn) { # nolint
  nn = intersect(nn, names(x))
  if (length(nn)) {
    x[, (nn) := NULL][]
  }
  x
}
