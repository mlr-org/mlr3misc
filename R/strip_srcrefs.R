#' @title Strip source references from objects
#'
#' @description
#' Source references can make objects unexpectedly large and are undesireable in many situations.
#' As \CRANpkg{renv} installs packages with the `--with-keep.source` option, we sometimes need to remove source references
#' from objects.
#' Methods should remove source references from the input, but should otherwise leave the input unchanged.
#'
#' @param x (`any`)\cr
#'   The object to strip of source references.
#' @param ... (`any`)\cr
#'   Additional arguments to the method.
#'
#' @keywords internal
#' @export
strip_srcrefs = function(x, ...) {
  UseMethod("strip_srcrefs")
}

#' @export
strip_srcrefs.default = function(x, ...) {
  x
}

#' @export
strip_srcrefs.function = function(x, ...) {
  attr(x, "srcref") = NULL
  x
}
