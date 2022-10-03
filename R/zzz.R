#' @import data.table
#' @import checkmate
#' @importFrom utils head tail adist
#' @importFrom stats setNames as.formula terms runif
#' @importFrom R6 R6Class is.R6
#' @importFrom digest digest
#' @importFrom methods formalArgs hasArg
"_PACKAGE"

.onLoad = function(libname, pkgname) {
  # nocov start
  backports::import(pkgname)
} # nocov end
