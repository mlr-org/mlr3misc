#' @title Apply Functions in the spirit of 'purrr'
#'
#' @description
#' `map`-like functions, similar to the ones implemented in \CRANpkg{purrr}:
#'
#' * `map()` returns the results of `.f` applied to `.x` as list.
#'   If `.f` is not a function, `map` will call `[[` on all elements of `.x` using the value of `.f` as index.
#' * `imap()` applies `.f` to each value of `.x` (passed as first argument) and its name (passed as second argument).
#'   If `.x` does not have names, a sequence along `.x` is passed as second argument instead.
#' * `pmap()` expects `.x` to be a list of vectors of equal length, and then applies `.f` to the first element of
#'   each vector of `.x`, then the second element of `.x`, and so on.
#' * `map_if()` applies `.f` to each element of `.x` where the predicate `.p` evaluates to `TRUE`.
#' * `map_at()` applies `.f` to each element of `.x` referenced by `.at`. All other elements remain unchanged.
#' * `keep()` keeps those elements of `.x` where predicate `.p` evaluates to `TRUE`.
#' * `discard()` discards those elements of `.x` where predicate `.p` evaluates to `TRUE`.
#' * `every()` is `TRUE` if predicate `.p` evaluates to `TRUE` for each `.x`.
#' * `some()` is `TRUE` if predicate `.p` evaluates to `TRUE` for at least one `.x`.
#' * `detect()` returns the first element where predicate `.p` evaluates to `TRUE`.
#' * `walk()`, `iwalk()` and `pwalk()` are the counterparts to `map()`, `imap()` and `pmap()`, but
#'   just visit (or change by reference) the elements of `.x`. They return input `.x` invisibly.
#'
#'
#' Additionally, the functions `map()`, `imap()` and `pmap()` have type-safe variants with the following suffixes:
#'
#' * `*_lgl()` returns a `logical(length(.x))`.
#' * `*_int()` returns a `integer(length(.x))`.
#' * `*_dbl()` returns a `double(length(.x))`.
#' * `*_chr()` returns a `character(length(.x))`.
#' * `*_br()` returns an object where the results of `.f` are put together with [base::rbind()].
#' * `*_bc()` returns an object where the results of `.f` are put together with [base::cbind()].
#' * `*_dtr()` returns a [data.table::data.table()] where the results of `.f` are put together
#'   in an [base::rbind()] fashion.
#' * `*_dtc()` returns a [data.table::data.table()] where the results of `.f` are put
#'   together in an [base::cbind()] fashion.
#'
#' @param .x (`list()` | atomic `vector()`).
#' @param .f (`function()` | `character()` | `integer()`)\cr
#'   Function to apply, or element to extract by name (if `.f` is `character()`) or position (if `.f` is `integer()`).
#' @param .p (`function()` | `logical()`)\cr
#'   Predicate function.
#' @param .at (`character()` | `integer()` | `logical()`)\cr
#'   Index vector.
#' @param ... (`any`)\cr
#'   Additional arguments passed down to `.f` or `.p`.
#' @param .fill (`logical(1)`)\cr
#'   Passed down to [data.table::rbindlist()].
#' @param .idcol (`logical(1)`)\cr
#'   Passed down to [data.table::rbindlist()].
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
  out = if (is.function(.f)) {
    vapply(.x, .f, FUN.VALUE = .value, USE.NAMES = FALSE, ...)
  } else {
    vapply(.x, `[[`, .f, FUN.VALUE = .value, USE.NAMES = FALSE, ...)
  }
  setNames(out, names(.x))
}

mapply_list = function(.f, .dots, .args = list()) {
  # assertions to avoid segfault (#56)
  assert_function(.f)
  assert_list(.args)
  stopifnot(is.list(.dots)) # also allow data.frame alike objects

  .mapply(.f, .dots, .args)
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
map_br = function(.x, .f, ...) {
  do.call(rbind, map(.x, .f, ...))
}

#' @export
#' @rdname compat-map
map_bc = function(.x, .f, ...) {
  do.call(cbind, map(.x, .f, ...))
}

#' @export
#' @rdname compat-map
map_dtr = function(.x, .f, ..., .fill = FALSE, .idcol = NULL) {
  rbindlist(unname(map(.x, .f, ...)), use.names = TRUE, fill = .fill, idcol = .idcol)
}

#' @export
#' @rdname compat-map
map_dtc = function(.x, .f, ...) {
  cols = map(.x, .f, ...)
  j = map_lgl(cols, function(x) !is.null(dim(x)) && !is.null(colnames(x)))
  names(cols)[j] = ""
  do.call(data.table, c(cols, list(check.names = TRUE)))
}


#' @export
#' @rdname compat-map
pmap = function(.x, .f, ...) {
  mapply_list(.f, .x, list(...))
}

#' @export
#' @rdname compat-map
pmap_lgl = function(.x, .f, ...) {
  out = mapply_list(.f, .x, list(...))
  tryCatch(as.vector(out, "logical"), warning = function(w) stop("Cannot convert to logical"))
}


#' @export
#' @rdname compat-map
pmap_int = function(.x, .f, ...) {
  out = mapply_list(.f, .x, list(...))
  tryCatch(as.vector(out, "integer"), warning = function(w) stop("Cannot convert to integer"))
}

#' @export
#' @rdname compat-map
pmap_dbl = function(.x, .f, ...) {
  out = mapply_list(.f, .x, list(...))
  tryCatch(as.vector(out, "double"), warning = function(w) stop("Cannot convert to double"))
}

#' @export
#' @rdname compat-map
pmap_chr = function(.x, .f, ...) {
  out = mapply_list(.f, .x, list(...))
  tryCatch(as.vector(out, "character"), warning = function(w) stop("Cannot convert to character"))
}

#' @export
#' @rdname compat-map
pmap_dtr = function(.x, .f, ..., .fill = FALSE, .idcol = NULL) {
  out = mapply_list(.f, .x, list(...))
  rbindlist(out, use.names = TRUE, fill = .fill, idcol = .idcol)
}

#' @export
#' @rdname compat-map
pmap_dtc = function(.x, .f, ...) {
  out = mapply_list(.f, .x, list(...))
  do.call(data.table, out)
}


#' @export
#' @rdname compat-map
imap = function(.x, .f, ...) {
  .nn = names(.x) %??% seq_along(.x)
  setNames(mapply_list(.f, list(.x, .nn), list(...)), names(.x))
}

#' @export
#' @rdname compat-map
imap_lgl = function(.x, .f, ...) {
  .nn = names(.x) %??% seq_along(.x)
  setNames(pmap_lgl(c(list(.x, .nn)), .f), names(.x))
}

#' @export
#' @rdname compat-map
imap_int = function(.x, .f, ...) {
  .nn = names(.x) %??% seq_along(.x)
  setNames(pmap_int(c(list(.x, .nn)), .f), names(.x))
}

#' @export
#' @rdname compat-map
imap_dbl = function(.x, .f, ...) {
  .nn = names(.x) %??% seq_along(.x)
  setNames(pmap_dbl(c(list(.x, .nn)), .f), names(.x))
}

#' @export
#' @rdname compat-map
imap_chr = function(.x, .f, ...) {
  .nn = names(.x) %??% seq_along(.x)
  setNames(pmap_chr(c(list(.x, .nn)), .f), names(.x))
}

#' @export
#' @rdname compat-map
imap_dtr = function(.x, .f, ..., .fill = FALSE, .idcol = NULL) {
  rbindlist(imap(.x, .f, ...), use.names = TRUE, fill = .fill, idcol = .idcol)
}

#' @export
#' @rdname compat-map
imap_dtc = function(.x, .f, ...) {
  do.call(data.table, imap(.x, .f, ...))
}

#' @export
#' @rdname compat-map
keep = function(.x, .f, ...) {
  UseMethod("keep")
}

#' @export
keep.default = function(.x, .f, ...) { # nolint
  .x[probe(.x, .f, ...)]
}

#' @export
keep.data.frame = function(.x, .f, ...) { # nolint
  .x[, probe(.x, .f, ...), drop = FALSE]
}

#' @export
keep.data.table = function(.x, .f, ...) { # nolint
  .x[, probe(.x, .f, ...), with = FALSE]
}

#' @export
#' @rdname compat-map
discard = function(.x, .p, ...) {
  UseMethod("discard")
}

#' @export
discard.default = function(.x, .p, ...) { # nolint
  .sel = probe(.x, .p, ...)
  .x[is.na(.sel) | !.sel]
}

#' @export
discard.data.frame = function(.x, .p, ...) { # nolint
  .sel = probe(.x, .p, ...)
  .x[, is.na(.sel) | !.sel, drop = FALSE]
}

#' @export
discard.data.table = function(.x, .p, ...) { # nolint
  .sel = probe(.x, .p, ...)
  .x[, is.na(.sel) | !.sel, with = FALSE]
}

#' @export
#' @rdname compat-map
map_if = function(.x, .p, .f, ...) {
  UseMethod("map_if")
}

#' @export
#' @rdname compat-map
map_if.default = function(.x, .p, .f, ...) { # nolint
  .matches = probe(.x, .p)
  .x[.matches] = map(.x[.matches], .f, ...)
  .x
}

#' @export
map_if.data.frame = function(.x, .p, .f, ...) { # nolint
  .matches = probe(.x, .p)
  .x[, .matches] = map(.x[, .matches, drop = FALSE], .f, ...)
  .x
}

#' @export
map_if.data.table = function(.x, .p, .f, ...) { # nolint
  .matches = which(probe(.x, .p))
  if (length(.matches)) {
    .x = copy(.x)
    for (j in .matches) {
      set(.x, j = j, value = .f(.x[[j]]))
    }
  }
  .x
}

#' @export
#' @rdname compat-map
map_at = function(.x, .at, .f, ...) {
  UseMethod("map_at")
}

#' @export
map_at.default = function(.x, .at, .f, ...) { # nolint
  .x[.at] = map(.x[.at], .f, ...)
  .x
}

#' @export
map_at.data.table = function(.x, .at, .f, ...) { # nolint
  if (length(.at)) {
    .x = copy(.x)
    for (j in .at) {
      set(.x, j = j, value = .f(.x[[j]]))
    }
  }
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

#' @export
#' @rdname compat-map
detect = function(.x, .p, ...) {
  for (i in seq_along(.x)) {
    .res = .p(.x[[i]], ...)
    if (!is.na(.res) && .res) {
      return(.x[[i]])
    }
  }
  return(NULL)
}

#' @export
#' @rdname compat-map
walk = function(.x, .f, ...) {
  for (.xi in .x) {
    .f(.xi, ...)
  }

  invisible(.x)
}

walk2 = function(.x, .f, ...) {
  .wrapper = function(...) { .f(...); NULL }
  map(.x, .wrapper, ...)

  invisible(.x)
}

#' @export
#' @rdname compat-map
iwalk = function(.x, .f, ...) {
  .nn = names(.x) %??% seq_along(.x)
  for (.i in seq_along(.x)) {
    .f(.x[[.i]], .nn[.i], ...)
  }

  invisible(.x)
}

#' @export
#' @rdname compat-map
pwalk = function(.x, .f, ...) {
  # a loop is too slow here, so we wrap the function and NULL the return value
  # this allows the GC to collect the return values of the function calls
  .wrapper = function(...) {
    .f(...)
    NULL
  }

  pmap(.x, .wrapper, ...)
  invisible(.x)
}
