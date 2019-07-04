#' @import data.table
#' @import checkmate
#' @importFrom utils head adist
#' @importFrom stats setNames as.formula terms runif
#' @importFrom R6 R6Class
"_PACKAGE"

.onLoad = function(libname, pkgname) { # nocov start
  backports::import(pkgname)
} # nocov end
