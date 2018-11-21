#' @export
#' @rdname insert_named
remove_named = function(x, nn) {
  UseMethod("remove_named")
}

#' @export
#' @rdname insert_named
remove_named.list = function(x, nn) {
  x[intersect(nn, names(x))] = NULL
  x
}

#' @export
#' @rdname insert_named
remove_named.environment = function(x, nn) {
  rm(list = intersect(nn, names(x)), envir = x)
  x
}

#' @export
#' @rdname insert_named
remove_named.data.frame = function(x, nn) {
  nn = setdiff(names(x), nn)
  x[, nn, drop = FALSE]
}

#' @export
#' @rdname insert_named
remove_named.data.table = function(x, nn) {
  nn = intersect(nn, names(x))
  if (length(nn))
    x[, (nn) := NULL]
  x
}
