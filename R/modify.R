#' @title Selectively Modify Elements of a Vector
#'
#' @description
#' Modifies elements of a vector selectively, similar to the functions in \CRANpkg{purrr}.
#'
#' `modify_if()` applies a predicate function `.p` to all elements of `.x`
#' and applies `.f` to those elements of `.x` where `.p` evaluates to `TRUE`.
#'
#' `modify_at()` applies `.f` to those elements of `.x` selected via `.at`.
#'
#' @param .x (`vector()`).
#' @param .p (`function()`)\cr
#'   Predicate function.
#' @param .f (`function()`)\cr
#'   Function to apply on `.x`.
#' @param .at ((`integer()` | `character()`))\cr
#'   Index vector to select elements from `.x`.
#' @param ... (`any`)\cr
#'   Additional arguments passed to `.f`.
#' @export
#' @examples
#' x = modify_if(iris, is.factor, as.character)
#' str(x)
#'
#' x = modify_at(iris, 5, as.character)
#' x = modify_at(iris, "Sepal.Length", sqrt)
#' str(x)
modify_if = function(.x, .p, .f, ...) {
  UseMethod("modify_if")
}

#' @export
modify_if.default = function(.x, .p, .f, ...) {
  sel = probe(.x, .p)
  .x[sel] = map(.x[sel], .f, ...)
  .x
}

#' @export
modify_if.data.table = function(.x, .p, .f, ...) {
  sel = names(which(probe(.x, .p)))
  .x[, (sel) := lapply(.SD, .f, ...), .SDcols = sel][]
}

#' @export
#' @rdname modify_if
modify_at = function(.x, .at, .f, ...) {
  UseMethod("modify_at")
}

#' @export
modify_at.default = function(.x, .at, .f, ...) {
  .x[.at] = map(.x[.at], .f, ...)
  .x
}

#' @export
modify_at.data.table = function(.x, .at, .f, ...) {
  .x[, (.at) := lapply(.SD, .f, ...), .SDcols = .at][]
}
