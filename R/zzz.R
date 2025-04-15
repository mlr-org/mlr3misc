#' @import data.table
#' @import checkmate
#' @importFrom utils head tail adist
#' @importFrom stats setNames as.formula terms runif
#' @importFrom R6 R6Class is.R6
#' @importFrom digest digest
#' @importFrom methods formalArgs hasArg
#' @importFrom utils capture.output
#' @importFrom cli cli_h1 cli_li cli_format_method
"_PACKAGE"

.onLoad = function(libname, pkgname) {
  # nocov start
  backports::import(pkgname)

  # setup logger
  # lg = lgr::get_logger("mlr3_ecosystem")
  # assign("lg", lg, envir = parent.env(environment()))
  # f = function(event) {
  #   event$msg = paste0("[mlr3_ecosystem] ", event$msg)
  #   TRUE
  # }
  # lg$set_filters(list(f))
  # if (Sys.getenv("IN_PKGDOWN") == "true") {
  #   lg$set_threshold("warn")
  # }
} # nocov end
