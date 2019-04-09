#' @rawNamespace import(data.table, except = transpose)
#' @import checkmate
#' @importFrom utils head adist
#' @importFrom stats setNames as.formula terms
NULL

.onLoad = function(libname, pkgname) { #nocov start
  backports::import(pkgname)
} #nocov end
