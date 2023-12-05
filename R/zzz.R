#' @import data.table
#' @import checkmate
#' @importFrom utils head tail adist
#' @importFrom stats setNames as.formula terms runif
#' @importFrom R6 R6Class is.R6
#' @importFrom digest digest
#' @importFrom methods formalArgs hasArg
#'
#' @section Package Options:
#' * `"mlr3misc.warn_srcref"`:
#'   Disable giving a warning during package loading when packages seem to be installed with the `"--with-keep.source"`
#'   option by setting this option to `FALSE`. Defaults to `TRUE`.
"_PACKAGE"

.onLoad = function(libname, pkgname) {
  # nocov start
  if (has_srcref(ids) && getOption("mlr3misc.warn_srcref", TRUE)) {
    warningf(paste0("It looks like you are installing packages with the '--with-keep.source' flag, which is discouraged.\n", # nolint
      "You can find more information on this on the FAQ section of our website: https://mlr-org.com/faq.html\n",
      "This warning can be disabled by setting the 'mlr3misc.warn_srcref' option to FALSE.\n"))
  }
  backports::import(pkgname)
} # nocov end
