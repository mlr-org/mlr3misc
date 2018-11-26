#' @import data.table
#' @import checkmate
#' @importFrom stats setNames
NULL

.onLoad = function(libname, pkgname) { #nocov start
  backports::import(pkgname)
} #nocov end
