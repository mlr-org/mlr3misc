#' @rawNamespace import(data.table, except = transpose)
#' @import checkmate
#' @importFrom utils head adist
#' @importFrom stats setNames
#' @importFrom fastmatch fmatch
NULL

.onLoad = function(libname, pkgname) { #nocov start
  backports::import(pkgname)
} #nocov end
