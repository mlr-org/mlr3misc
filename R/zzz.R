#' @import data.table
#' @import checkmate
#' @importFrom utils head adist
#' @importFrom stats setNames as.formula terms runif
NULL

.onLoad = function(libname, pkgname) {
  # nocov start
  backports::import(pkgname)
} # nocov end
