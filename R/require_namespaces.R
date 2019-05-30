#' @title Require Multiple Namespaces
#'
#' @description
#' Packages are loaded (not attached) via [base::requireNamespace()].
#' If at least on package can not be loaded, an exception of class "packageNotFoundError" is raised.
#' The character vector of missing packages is stored in the condition as `packages`.
#'
#' @param pkgs :: `character()`\cr
#'   Packages to load.
#' @param msg :: `character(1)`\cr
#'   Message to print on error. `"%s"` is placeholder for the list of packages.
#'
#' @export
#' @examples
#' require_namespaces("mlr3misc")
#'
#' # catch condition, return missing packages
#' tryCatch(require_namespaces(c("mlr3misc", "foobaaar")),
#'   packageNotFoundError = function(e) e$packages)
require_namespaces = function(pkgs, msg = "The following packages could not be loaded: %s") {
  pkgs = unique(assert_character(pkgs, any.missing = FALSE))
  ii = which(!map_lgl(pkgs, requireNamespace, quietly = TRUE))
  if (length(ii)) {
    msg = sprintf(msg, paste0(pkgs[ii], collapse = ","))
    stop(errorCondition(msg, packages = pkgs[ii], class = "packageNotFoundError"))
  }
  invisible(pkgs)
}
