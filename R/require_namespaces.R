#' @title Require Multiple Namespaces
#'
#' @description
#' Packages are loaded (not attached) via [base::requireNamespace()].
#' If at least on package can not be loaded, an exception of class "packageNotFoundError" is raised.
#' The character vector of missing packages is stored in the condition as `packages`.
#'
#' @param pkgs (`character()`)\cr
#'   Packages to load.
#' @param msg (`character(1)`)\cr
#'   Message to print on error. Use `"%s"` as placeholder for the list of packages.
#' @param quietly (`logical(1)`)\cr
#'   If `TRUE` then returns `TRUE` if all packages are loaded, otherwise `FALSE`.
#'
#'
#' @return (`character()`) of loaded packages (invisibly).
#' @export
#' @examples
#' require_namespaces("mlr3misc")
#'
#' # catch condition, return missing packages
#' tryCatch(require_namespaces(c("mlr3misc", "foobaaar")),
#'   packageNotFoundError = function(e) e$packages)
require_namespaces = function(pkgs, msg = "The following packages could not be loaded: %s",
  quietly = FALSE) {
  pkgs = unique(assert_character(pkgs, any.missing = FALSE))
  ii = which(!map_lgl(pkgs, requireNamespace, quietly = TRUE))

  if (length(ii)) {
    if (quietly) {
      return(FALSE)
    }
    msg = sprintf(msg, paste0(pkgs[ii], collapse = ","))
    stop(errorCondition(msg, packages = pkgs[ii], class = "packageNotFoundError"))
  } else if (quietly) {
    return(TRUE)
  } else {
    invisible(pkgs)
  }
}
