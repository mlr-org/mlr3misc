#' @rawNamespace import(data.table, except = transpose)
#' @import checkmate
#' @importFrom utils head
#' @importFrom stats setNames
NULL

.onLoad = function(libname, pkgname) { #nocov start
  backports::import(pkgname)
} #nocov end
