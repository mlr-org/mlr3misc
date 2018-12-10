#' @rawNamespace import(data.table, except = transpose)
#' @import checkmate
#' @importFrom utils head
NULL

.onLoad = function(libname, pkgname) { #nocov start
  backports::import(pkgname)
} #nocov end
