#' @title Require multiple packages
#'
#' @description
#' Packages are loaded (not attached) via [base::requireNamespace()].
#' If at least on package can not be loaded, an exception is raised.
#' @param pkgs (`character()`)\cr
#'  Packages to load.
#' @param msg (`character(1)`)\cr
#'  Message to print on error. `"%s"` is placehold for the list of packages.
#'
#' @export
#' @examples
#' require_namespaces("mlr3misc")
require_namespaces = function(pkgs, msg = "The following packages could not be loaded: %s") {
  pkgs = unique(assert_character(pkgs, any.missing = FALSE))
  ii = which(!map_lgl(pkgs, requireNamespace, quietly = TRUE))
  if (length(ii))
    stopf(msg, paste0(pkgs[ii], collapse = ","))
  invisible(pkgs)
}
