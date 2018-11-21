#' @title Purrr-like map
#'
#' @description
#' A `map`-operation, similar to the one implemented in \pkg{purrr}.
#'
#' `map` returns the results of `.f` applied to `.x` as list.
#' If `.f` is not a function, `map` will call `[[` on all elements of `.x` using
#' the value of `.f` as index.
#'
#' The other `map` variants ensure type safety:
#'
#' * `map_lgl` returns a `logical(length(.x))`.
#' * `map_int` returns a `integer(length(.x))`.
#' * `map_dbl` returns a `double(length(.x))`.
#' * `map_chr` returns a `character(length(.x))`.
#' * `map_dtr` returns a [data.table::data.table()] where the results of `.f` are put together in an [base::rbind()] fashion.
#' * `map_dtc` returns a [data.table::data.table()] where the results of `.f` are put together in an [base::cbind()] fashion.
#'
#' @param .x \[`list()` or atomic `vector`\].
#' @param .f \[`function`\ | `character` | `integer`].
#' @param ... \[any\]:\cr
#'  Additional arguments passed to `.f`.
#' @param .fill \[`logical(1)`\]:\cr
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
  setDT(map(.x, .f, ...))
}
