#' @title Purrr-like apply functions
#'
#' @description
#' `map`-like functions, similar to the ones implemented in \pkg{purrr}.
#'
#' `map()` returns the results of `.f` applied to `.x` as list.
#' If `.f` is not a function, `map` will call `[[` on all elements of `.x` using
#' the value of `.f` as index.
#'
#' The other `map` variants ensure type safety:
#'
#' * `map_lgl()` returns a `logical(length(.x))`.
#' * `map_int()` returns a `integer(length(.x))`.
#' * `map_dbl()` returns a `double(length(.x))`.
#' * `map_chr()` returns a `character(length(.x))`.
#' * `map_dtr()` returns a [data.table::data.table()] where the results of `.f` are put together in an [base::rbind()] fashion.
#' * `map_dtc()` returns a [data.table::data.table()] where the results of `.f` are put together in an [base::cbind()] fashion.
#'
#' `imap()` applies `.f` to each value of `.x` (passed as first argument) and its name (passed as second argument).
#' If `.x` does not have names, a sequence along `.x` is passed as second argument instead.
#'
#' `pmap()` expects `.x` to be a list of vectors of equal length, and then applies `.f` to the first element of each vector
#' of `.x`, then the second element of `.x`, and so on.
#'
#' `map_if()` applies `.f` to each element of `.x` where the predicate `.p` evaluates to `TRUE`.
#'
#' `keep()` keeps those elements of `.x` where predicate `.p` evaluates to `TRUE`, while `discard()` discards them.
#'
#' `every()` is `TRUE` if predicate `.p` evaluates to `TRUE` for each `.x`.
#' `some()` is `TRUE` if predicate `.p` evaluates to `TRUE` for at least one `.x`.
#'
#'
#' @param .x (`list()` or atomic `vector`).
#' @param .f (`function`\ | `character` | `integer`].
#'  Function to apply.
#' @param .p (`function`\ | `logical`].
#'  Predicate function.
#' @param ... :\cr
#'  Additional arguments passed down to `.f` or `.p`.
#' @param .fill (`logical(1)`):\cr
#'  Passed down to [data.table::rbindlist()].
#'
#' @name compat-map
NULL

#' @export
#' @rdname compat-map
map = function(.x, .f, ...) {
  if (is.function(.f)) {
    lapply(.x, .f, ...)
  } else {
    lapply(.x, `[[`, .f, ...)
  }
}

map_mold = function(.x, .f, .value, ...) {
  out = if (is.function(.f))
    vapply(.x, .f, FUN.VALUE = .value, USE.NAMES = FALSE, ...)
  else
    vapply(.x, `[[`, .f, FUN.VALUE = .value, USE.NAMES = FALSE, ...)
  names(out) = names(.x)
  out
}

probe = function(.x, .p, ...) {
  if (is.logical(.p)) {
    stopifnot(length(.p) == length(.x))
    .p
  } else {
    map_lgl(.x, .p, ...)
  }
}

#' @export
#' @rdname compat-map
map_lgl = function(.x, .f, ...) {
  map_mold(.x, .f, NA, ...)
}

#' @export
#' @rdname compat-map
map_int = function(.x, .f, ...) {
  map_mold(.x, .f, NA_integer_, ...)
}

#' @export
#' @rdname compat-map
map_dbl = function(.x, .f, ...) {
  map_mold(.x, .f, NA_real_, ...)
}

#' @export
#' @rdname compat-map
map_chr = function(.x, .f, ...) {
  map_mold(.x, .f, NA_character_, ...)
}

#' @export
#' @rdname compat-map
map_dtr = function(.x, .f, ..., .fill = FALSE) {
  rbindlist(map(.x, .f, ...), fill = .fill)
}

#' @export
#' @rdname compat-map
map_dtc = function(.x, .f, ...) {
  do.call(data.table, map(.x, .f, ...))
}


#' @export
#' @rdname compat-map
imap = function(.x, .f, ...) {
  nn = names(.x)
  if (is.null(nn))
    nn = seq_along(.x)
  out = .mapply(.f, c(list(.x, nn), list(...)), list())
  names(out) = names(.x)
  out
}

#' @export
#' @rdname compat-map
pmap = function(.x, .f, ...) {
  .mapply(.f, .x, list(...))
}

#' @export
#' @rdname compat-map
keep = function(.x, .f, ...) {
  .x[probe(.x, .f, ...)]
}

#' @export
#' @rdname compat-map
discard = function(.x, .p, ...) {
  sel <- probe(.x, .p, ...)
  .x[is.na(sel) | !sel]
}

#' @export
#' @rdname compat-map
map_if = function(.x, .p, .f, ...) {
  matches <- probe(.x, .p)
  .x[matches] <- map(.x[matches], .f, ...)
  .x
}

#' @export
#' @rdname compat-map
every = function(.x, .p, ...) {
  ok = all(map_lgl(.x, .p, ...), na.rm = FALSE)
  !is.na(ok) && ok
}

#' @export
#' @rdname compat-map
some = function(.x, .p, ...) {
  any(map_lgl(.x, .p, ...), na.rm = TRUE)
}
